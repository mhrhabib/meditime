import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meditime/features/onboarding/presentation/cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final TextEditingController _nameController = TextEditingController();
  String _selectedGoal = 'Manage my medications';

  final List<String> _goals = [
    'Manage my medications',
    'Track family health',
    'Improve health habits',
    'Never miss a dose',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    } else {
      _complete();
    }
  }

  void _complete() {
    context.read<OnboardingCubit>().completeOnboarding();
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cs.surface,
              cs.primaryContainer.withOpacity(0.05),
              cs.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(cs),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentStep = i),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildWelcomeStep(cs),
                    _buildUserInfoStep(cs),
                    _buildBenefitsStep(cs),
                    _buildPremiumStep(cs),
                  ],
                ),
              ),
              _buildBottomAction(cs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(4, (i) => _buildDot(i, cs)),
          ),
          if (_currentStep < 3)
            TextButton(
              onPressed: _complete,
              child: Text('Skip', style: TextStyle(color: cs.outline)),
            ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, ColorScheme cs) {
    final isActive = _currentStep == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 6,
      width: isActive ? 18 : 6,
      decoration: BoxDecoration(
        color: isActive ? cs.primary : cs.outlineVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildStepBase({
    required String title,
    required String subtitle,
    required Widget visual,
    ColorScheme? cs,
  }) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Center(child: visual),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: tt.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: cs?.onSurface,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: tt.bodyLarge?.copyWith(
              color: cs?.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildWelcomeStep(ColorScheme cs) {
    return _buildStepBase(
      cs: cs,
      title: 'Welcome to MediTime',
      subtitle: 'The smart way to manage your medications and stay healthy together.',
      visual: Image.asset(
        'assets/images/onboarding/welcome.png',
        fit: BoxFit.contain,
      ).animate().scale(delay: 100.ms).fadeIn(),
    );
  }

  Widget _buildUserInfoStep(ColorScheme cs) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/onboarding/user_info.png', height: 200)
              .animate().fadeIn().scale(),
          const SizedBox(height: 40),
          Text('Personalize Your Experience', 
            style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'What should we call you?',
              hintText: 'Enter your name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            onChanged: (val) {
               context.read<OnboardingCubit>().updateUserInfo(name: val);
            },
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedGoal,
            decoration: const InputDecoration(
              labelText: 'Your primary goal',
              prefixIcon: Icon(Icons.track_changes_rounded),
            ),
            items: _goals.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (val) {
              setState(() => _selectedGoal = val!);
              context.read<OnboardingCubit>().updateUserInfo(goal: val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsStep(ColorScheme cs) {
    return _buildStepBase(
      cs: cs,
      title: 'Never Miss a Dose',
      subtitle: 'Set smart reminders, track your supply, and get health insights automatically.',
      visual: Image.asset(
        'assets/images/onboarding/reminders.png',
        fit: BoxFit.contain,
      ).animate().shake(delay: 500.ms, hz: 4),
    );
  }

  Widget _buildPremiumStep(ColorScheme cs) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset('assets/images/onboarding/premium.png', height: 220)
              .animate(onPlay: (c) => c.repeat())
              .shimmer(delay: 2.seconds, duration: 1.5.seconds),
          const SizedBox(height: 32),
          Text('Unlock MediTime Plus', 
            style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w900, color: cs.primary)),
          const SizedBox(height: 12),
          Text('Unlimited family members, cloud sync, and advanced health reports.',
            textAlign: TextAlign.center,
            style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.stars_rounded, color: cs.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Start your 7-day free trial today. Cancel anytime.',
                    style: tt.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBottomAction(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _nextPage,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                _currentStep == 3 ? 'Start 7-Day Free Trial' : 'Continue',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
            ),
          ),
          if (_currentStep == 3)
            TextButton(
              onPressed: _complete,
              child: Text('Continue with basic version', 
                style: TextStyle(color: cs.outline, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}
