import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:meditime/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:meditime/features/onboarding/presentation/widgets/age_page.dart';
import 'package:meditime/features/onboarding/presentation/widgets/benefits_page.dart';
import 'package:meditime/features/onboarding/presentation/widgets/conditions_page.dart';
import 'package:meditime/features/onboarding/presentation/widgets/gender_page.dart';
import 'package:meditime/features/onboarding/presentation/widgets/how_reminders_page.dart';
import 'package:meditime/features/onboarding/presentation/widgets/name_page.dart';
import 'package:meditime/features/onboarding/presentation/widgets/notifications_page.dart';
import 'package:meditime/features/onboarding/presentation/widgets/premium_page.dart';
import 'package:meditime/features/onboarding/presentation/widgets/setup_complete_page.dart';
import 'package:meditime/features/onboarding/presentation/widgets/shared.dart';
import 'package:meditime/features/onboarding/presentation/widgets/welcome_page.dart';

// ═══════════════════════════════════════════════════════════════
// MAIN ONBOARDING SCREEN
// ═══════════════════════════════════════════════════════════════

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // 0=Welcome, 1=Name, 2=Age, 3=Gender, 4=Conditions, 5=HowReminders,
  // 6=Benefits, 7=Notifications, 8=SetupComplete, 9=Premium
  static const int _totalPages = 10;

  // Temp holders so we can emit saveUserInfo once all three are collected.
  String _name = '';
  int? _age;
  String _gender = 'Male';

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _finish() {
    context.read<OnboardingCubit>().completeOnboarding();
    context.go('/');
  }

  // Pages that show the progress bar (skip for welcome + premium)
  bool get _showProgress => _currentPage > 0 && _currentPage < _totalPages - 1;
  bool get _showBack => _currentPage > 0 && _currentPage < _totalPages - 1;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: (_currentPage == 0 || _currentPage == _totalPages - 1) ? cs.primaryContainer : cs.surface,
        body: Column(
          children: [
            // ── Top bar (hidden on welcome + premium for full-bleed hero) ──
            if (_currentPage != 0 && _currentPage != _totalPages - 1)
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Row(
                    children: [
                      // Back button
                      if (_showBack)
                        IconButton(
                          icon: Icon(Icons.arrow_back_rounded, size: 24.r),
                          onPressed: _previousPage,
                          style: IconButton.styleFrom(
                            backgroundColor: cs.surfaceContainerHighest,
                            minimumSize: Size(40.r, 40.r),
                          ),
                        )
                      else
                        SizedBox(width: 40.r),

                      // Progress dots + step label
                      if (_showProgress)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ProgressDots(
                                  total: _totalPages - 2,
                                  current: _currentPage - 1,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'Step $_currentPage of ${_totalPages - 2} · ${(_currentPage / (_totalPages - 2) * 100).round()}% done',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    color: cs.outline,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox()),

                      // Skip
                      if (_currentPage > 0 && _currentPage < _totalPages - 1)
                        TextButton(
                          onPressed: () {
                            // Jump to premium page
                            _pageController.animateToPage(
                              _totalPages - 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                            );
                          },
                          child: Text('Skip',
                              style: TextStyle(color: cs.outline, fontWeight: FontWeight.w600, fontSize: 13.sp)),
                        )
                      else
                        SizedBox(width: 48.w),
                    ],
                  ),
                ),
              ),

            // ── Page content ──────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  // Page 0 — Welcome
                  WelcomePage(onNext: _nextPage),

                  // Page 1 — Name
                  NamePage(
                    initial: _name,
                    onNext: (v) {
                      setState(() => _name = v);
                      _nextPage();
                    },
                  ),

                  // Page 2 — Age
                  AgePage(
                    initial: _age,
                    onNext: (v) {
                      setState(() => _age = v);
                      _nextPage();
                    },
                  ),

                  // Page 3 — Gender
                  GenderPage(
                    initial: _gender,
                    onNext: (v) {
                      setState(() => _gender = v);
                      context.read<OnboardingCubit>().saveUserInfo(
                            name: _name,
                            age: _age ?? 0,
                            gender: v,
                          );
                      _nextPage();
                    },
                  ),

                  // Page 4 — Conditions
                  ConditionsPage(onNext: _nextPage),

                  // Page 5 — How Reminders Work
                  HowRemindersPage(onNext: _nextPage),

                  // Page 6 — Benefits
                  BenefitsPage(onNext: _nextPage),

                  // Page 7 — Notifications Permission
                  NotificationsPage(onNext: _nextPage),

                  // Page 8 — Setup Complete
                  SetupCompletePage(onNext: _nextPage, name: _name),

                  // Page 9 — Premium Paywall
                  PremiumPage(onStart: _finish, onSkip: _finish),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
