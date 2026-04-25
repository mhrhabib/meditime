import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/sync/sync_service.dart';
import 'package:meditime/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:meditime/features/auth/presentation/cubit/auth_state.dart';
import 'package:meditime/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Artificial delay for splash effect
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final onboardingCubit = context.read<OnboardingCubit>();
    if (!onboardingCubit.state.isLoaded) {
      await onboardingCubit.stream.firstWhere((s) => s.isLoaded);
    }

    if (!mounted) return;

    // Not authenticated → straight to sign-in.
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      context.go('/sign-in');
      return;
    }

    // Authenticated → pull remote state so we can trust profile existence.
    // If sync fails (offline / transient), fall back to whatever is local.
    try {
      await SyncService.instance
          .sync(immediate: true)
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      // ignore — decide based on local state
    }

    if (!mounted) return;

    // Give the watch stream a tick to propagate synced rows into cubit state.
    final profileCubit = context.read<ProfileCubit>();
    if (profileCubit.state.profiles.isEmpty) {
      await profileCubit.stream
          .firstWhere((s) => s.profiles.isNotEmpty)
          .timeout(const Duration(milliseconds: 500),
              onTimeout: () => profileCubit.state);
    }

    if (!mounted) return;

    final hasProfiles = profileCubit.state.profiles.isNotEmpty;
    if (hasProfiles && !onboardingCubit.state.hasCompletedOnboarding) {
      await onboardingCubit.completeOnboarding();
    }

    if (!mounted) return;
    context.go(hasProfiles ? '/' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Icon with Pulse Animation
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                size: 80,
                color: Colors.white,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                    duration: 1500.ms,
                    color: Colors.white.withValues(alpha: 0.3))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),

            const SizedBox(height: 32),

            // App Name with Slide and Fade
            const Text(
              'MediTime',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1.5,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(
                begin: 0.3,
                end: 0,
                curve: Curves.easeOutBack,
                duration: 800.ms),

            const SizedBox(height: 8),

            // Tagline
            Text(
              'Smart Health Companion',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: 1.5,
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }
}
