import 'package:go_router/go_router.dart';
import 'package:meditime/app/app_shell.dart';
import 'package:meditime/features/onboarding/presentation/screens/on_boarding_screen.dart';
import 'package:meditime/features/onboarding/presentation/screens/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
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
        path: '/',
        builder: (context, state) => const AppShell(),
      ),
    ],
  );
}
