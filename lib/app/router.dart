import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditime/app/app_shell.dart';
import 'package:meditime/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:meditime/features/auth/presentation/cubit/auth_state.dart';
import 'package:meditime/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:meditime/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:meditime/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:meditime/features/onboarding/presentation/screens/on_boarding_screen.dart';
import 'package:meditime/features/onboarding/presentation/screens/splash_screen.dart';

class AppRouter {
  static GoRouter buildRouter(AuthCubit authCubit) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: _AuthListenable(authCubit),
      redirect: (context, state) {
        final authState = authCubit.state;
        final onAuthRoute = state.matchedLocation == '/sign-in' ||
            state.matchedLocation == '/sign-up' ||
            state.matchedLocation == '/forgot-password';
        final onSplash = state.matchedLocation == '/splash';
        final onBoarding = state.matchedLocation == '/onboarding';

        // Splash is always allowed — it's the gate that decides next hop.
        if (onSplash) return null;

        // Not authenticated: only auth routes are reachable.
        if (authState is! AuthAuthenticated) {
          return onAuthRoute ? null : '/sign-in';
        }

        // Authenticated: bounce off auth routes via splash so we can
        // wait for the initial sync and inspect profiles before deciding
        // whether to show onboarding or go home.
        if (onAuthRoute) return '/splash';

        // Authenticated users are allowed on onboarding (post-auth new-user flow).
        if (onBoarding) return null;

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: '/sign-up',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const AppShell(),
        ),
      ],
    );
  }
}

/// Makes GoRouter re-evaluate its redirect every time AuthCubit emits.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(AuthCubit cubit) {
    cubit.stream.listen((_) => notifyListeners());
  }
}
