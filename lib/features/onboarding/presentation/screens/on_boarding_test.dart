import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meditime/features/onboarding/presentation/cubit/onboarding_cubit.dart';

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

  // Total pages: 0=Welcome, 1=UserInfo, 2=Conditions, 3=HowReminders, 4=Benefits, 5=Notifications, 6=Premium
  static const int _totalPages = 7;

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
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            _currentPage == 0 ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: cs.surface,
        body: Column(
          children: [
            // ── Top bar ──────────────────────────────────────
            SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    // Back button
                    if (_showBack)
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: _previousPage,
                        style: IconButton.styleFrom(
                          backgroundColor: cs.surfaceContainerHighest,
                          minimumSize: const Size(40, 40),
                        ),
                      )
                    else
                      const SizedBox(width: 40),

                    // Progress dots
                    if (_showProgress)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: _ProgressDots(
                            total: _totalPages - 2, // exclude welcome + premium
                            current: _currentPage - 1,
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
                            style: TextStyle(
                                color: cs.outline,
                                fontWeight: FontWeight.w600)),
                      )
                    else
                      const SizedBox(width: 48),
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
                  _WelcomePage(onNext: _nextPage),
                  _UserInfoPage(onNext: _nextPage),
                  _ConditionsPage(onNext: _nextPage),
                  _HowRemindersPage(onNext: _nextPage),
                  _BenefitsPage(onNext: _nextPage),
                  _NotificationsPage(onNext: _nextPage),
                  _PremiumPage(onStart: _finish, onSkip: _finish),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PROGRESS DOTS
// ═══════════════════════════════════════════════════════════════

class _ProgressDots extends StatelessWidget {
  final int total;
  final int current;

  const _ProgressDots({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? cs.primary : cs.outlineVariant,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAGE 0 — WELCOME (full-screen hero)
// ═══════════════════════════════════════════════════════════════

class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      color: cs.primaryContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
          child: Column(
            children: [
              const Spacer(),
              // Hero illustration
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.medication_rounded,
                    size: 72, color: Colors.white),
              ),
              const SizedBox(height: 40),
              Text(
                'MediTime',
                style: tt.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.onPrimaryContainer,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your personal health companion.\nNever miss a dose again.',
                style: tt.bodyLarge?.copyWith(
                  color: cs.onPrimaryContainer.withOpacity(0.75),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Stats row
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const _StatBadge(
                        value: '50%', label: 'miss their\nmeds daily'),
                    Container(
                        width: 1,
                        height: 40,
                        color: cs.primary.withOpacity(0.3)),
                    const _StatBadge(
                        value: '78%', label: 'improve\nwith reminders'),
                    Container(
                        width: 1,
                        height: 40,
                        color: cs.primary.withOpacity(0.3)),
                    const _StatBadge(
                        value: '125K', label: 'deaths avoided\nper year'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onNext,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    backgroundColor: cs.primary,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Let's get started",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Colors.white)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No account needed to start',
                style: tt.bodySmall
                    ?.copyWith(color: cs.onPrimaryContainer.withOpacity(0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  const _StatBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: cs.primary)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                color: cs.onPrimaryContainer.withOpacity(0.65),
                height: 1.3),
            textAlign: TextAlign.center),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAGE 1 — USER INFO
// ═══════════════════════════════════════════════════════════════

class _UserInfoPage extends StatefulWidget {
  final VoidCallback onNext;
  const _UserInfoPage({required this.onNext});

  @override
  State<_UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<_UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PageHeader(
              icon: Icons.person_outline_rounded,
              title: "Tell us about\nyourself",
              subtitle: 'This helps personalise your experience and reminders.',
            ),
            const SizedBox(height: 32),

            // Name field
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Your name',
                hintText: 'e.g. Rafiq',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 16),

            // Age field
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Age',
                hintText: 'e.g. 34',
                prefixIcon: Icon(Icons.cake_outlined),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your age';
                final age = int.tryParse(v);
                if (age == null || age < 1 || age > 120)
                  return 'Enter a valid age';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Gender selector
            Text('Gender', style: tt.labelLarge),
            const SizedBox(height: 10),
            Row(
              children: ['Male', 'Female', 'Other'].map((g) {
                final isSelected = _selectedGender == g;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: g != 'Other' ? 10 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGender = g),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cs.primaryContainer
                              : cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? cs.primary : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              g == 'Male'
                                  ? Icons.male_rounded
                                  : g == 'Female'
                                      ? Icons.female_rounded
                                      : Icons.transgender_rounded,
                              color: isSelected ? cs.primary : cs.outline,
                              size: 26,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              g,
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                                color: isSelected ? cs.primary : cs.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            _NextButton(
              label: 'Continue',
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  context.read<OnboardingCubit>().saveUserInfo(
                        name: _nameController.text.trim(),
                        age: int.parse(_ageController.text),
                        gender: _selectedGender,
                      );
                  widget.onNext();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAGE 2 — CONDITIONS
// ═══════════════════════════════════════════════════════════════

class _ConditionsPage extends StatefulWidget {
  final VoidCallback onNext;
  const _ConditionsPage({required this.onNext});

  @override
  State<_ConditionsPage> createState() => _ConditionsPageState();
}

class _ConditionsPageState extends State<_ConditionsPage> {
  final Set<String> _selected = {};

  static const _conditions = [
    ('Diabetes', Icons.water_drop_outlined),
    ('Hypertension / BP', Icons.favorite_outline_rounded),
    ('Heart disease', Icons.monitor_heart_outlined),
    ('Asthma', Icons.air_outlined),
    ('Thyroid', Icons.medical_services_outlined),
    ('Kidney disease', Icons.healing_outlined),
    ('Cholesterol', Icons.science_outlined),
    ('Anxiety / Depression', Icons.psychology_outlined),
    ('Arthritis', Icons.accessibility_new_outlined),
    ('Other', Icons.add_circle_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(
            icon: Icons.health_and_safety_outlined,
            title: 'Any health\nconditions?',
            subtitle:
                'Select all that apply. We\'ll personalise reminders and alerts for you.',
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _conditions.map((c) {
              final isSelected = _selected.contains(c.$1);
              return GestureDetector(
                onTap: () => setState(() {
                  if (isSelected)
                    _selected.remove(c.$1);
                  else
                    _selected.add(c.$1);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cs.primaryContainer
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: isSelected ? cs.primary : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(c.$2,
                          size: 16,
                          color: isSelected ? cs.primary : cs.outline),
                      const SizedBox(width: 6),
                      Text(
                        c.$1,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? cs.primary : cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'None of the above? That\'s fine — tap Continue.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: cs.outline),
          ),
          const SizedBox(height: 32),
          _NextButton(
            label: 'Continue',
            onTap: () {
              context
                  .read<OnboardingCubit>()
                  .saveConditions(_selected.toList());
              widget.onNext();
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAGE 3 — HOW REMINDERS WORK (interactive tutorial)
// ═══════════════════════════════════════════════════════════════

class _HowRemindersPage extends StatefulWidget {
  final VoidCallback onNext;
  const _HowRemindersPage({required this.onNext});

  @override
  State<_HowRemindersPage> createState() => _HowRemindersPageState();
}

class _HowRemindersPageState extends State<_HowRemindersPage> {
  int _activeStep = 0;

  static const _steps = [
    (
      icon: Icons.add_circle_outline_rounded,
      title: 'Add your medicine',
      body:
          'Tap + on the home screen. Enter the name, dosage and type. Takes 30 seconds.',
      color: Color(0xFF0B6E6E),
    ),
    (
      icon: Icons.access_time_rounded,
      title: 'Set your schedule',
      body:
          'Choose daily, weekly or custom times. Set Before meal, After meal or Empty stomach.',
      color: Color(0xFF1B6B3A),
    ),
    (
      icon: Icons.notifications_active_rounded,
      title: 'Get reminded',
      body:
          'We ring an alarm at your set time. Confirm, skip or snooze — right from the notification.',
      color: Color(0xFF7A4F00),
    ),
    (
      icon: Icons.inventory_2_outlined,
      title: 'Track your stock',
      body:
          'We auto-count your remaining doses. Get a refill alert 3 days before you run out.',
      color: Color(0xFF4A6363),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final step = _steps[_activeStep];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _PageHeader(
                    icon: Icons.play_lesson_outlined,
                    title: 'How reminders\nwork',
                    subtitle: 'Simple 4-step setup. Done in under a minute.',
                  ),
                  const SizedBox(height: 24),

                  // Step selector tabs
                  Row(
                    children: List.generate(_steps.length, (i) {
                      final active = i == _activeStep;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeStep = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                            height: 4,
                            decoration: BoxDecoration(
                              color: active ? cs.primary : cs.outlineVariant,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  // Active step card
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(_activeStep),
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color(step.color.value).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Color(step.color.value).withOpacity(0.25)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: step.color,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(step.icon,
                                    color: Colors.white, size: 26),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Step ${_activeStep + 1} of ${_steps.length}',
                                      style: tt.labelSmall
                                          ?.copyWith(color: cs.outline),
                                    ),
                                    Text(
                                      step.title,
                                      style: tt.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            step.body,
                            style: tt.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Step bullets
                  ...List.generate(_steps.length, (i) {
                    final active = i == _activeStep;
                    return GestureDetector(
                      onTap: () => setState(() => _activeStep = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: active
                              ? cs.primaryContainer.withOpacity(0.4)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: active
                                ? cs.primary.withOpacity(0.3)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: active
                                    ? cs.primary
                                    : cs.surfaceContainerHighest,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: active
                                  ? const Icon(Icons.check_rounded,
                                      size: 14, color: Colors.white)
                                  : Text('${i + 1}',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: cs.outline)),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _steps[i].title,
                              style: tt.labelLarge?.copyWith(
                                color:
                                    active ? cs.primary : cs.onSurfaceVariant,
                                fontWeight:
                                    active ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _NextButton(label: 'Got it — continue', onTap: widget.onNext),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAGE 4 — BENEFITS (animated cards)
// ═══════════════════════════════════════════════════════════════

class _BenefitsPage extends StatelessWidget {
  final VoidCallback onNext;
  const _BenefitsPage({required this.onNext});

  static const _benefits = [
    (
      Icons.alarm_on_rounded,
      '78% better adherence',
      'Users who set reminders take 78% more doses on time vs those who don\'t.',
      Color(0xFF0B6E6E)
    ),
    (
      Icons.family_restroom_rounded,
      'Whole family, one app',
      'Manage medicines for parents, children and spouse — all from one screen.',
      Color(0xFF1B6B3A)
    ),
    (
      Icons.inventory_2_outlined,
      'Never run out',
      'Smart refill alerts 3 days before your medicine finishes. Tap to reorder.',
      Color(0xFF7A4F00)
    ),
    (
      Icons.emergency_rounded,
      'Emergency card',
      'Share your blood group, allergies and medicines with first responders instantly — no unlock required.',
      Color(0xFFBA1A1A)
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(
            icon: Icons.star_outline_rounded,
            title: 'Why MediTime\nworks',
            subtitle: 'Built around real reasons people miss their medicines.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _benefits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final b = _benefits[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (b.$4).withOpacity(0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: (b.$4).withOpacity(0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: b.$4,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(b.$1, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.$2,
                                style: tt.titleSmall?.copyWith(
                                    color: b.$4, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(b.$3,
                                style: tt.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant, height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _NextButton(label: 'Enable reminders', onTap: onNext),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAGE 5 — NOTIFICATIONS PERMISSION
// ═══════════════════════════════════════════════════════════════

class _NotificationsPage extends StatelessWidget {
  final VoidCallback onNext;
  const _NotificationsPage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Column(
        children: [
          // Notification mockup illustration
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications_active_rounded,
                      size: 52, color: cs.primary),
                ),
                const SizedBox(height: 28),
                Text(
                  "Don't miss a dose",
                  style: tt.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900, letterSpacing: -0.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Allow notifications so MediTime can ring your alarm at the right time — even when your screen is off.',
                  style: tt.bodyLarge
                      ?.copyWith(color: cs.onSurfaceVariant, height: 1.6),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Simulated notification card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.medication_rounded,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MediTime',
                                style: tt.labelMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            Text('Time to take Metformin 500mg',
                                style: tt.bodySmall
                                    ?.copyWith(color: cs.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Text('now',
                          style: tt.labelSmall?.copyWith(color: cs.outline)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Action buttons mockup
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF3DE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text('Take now',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Color(0xFF27500A))),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAEEDA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text('Snooze',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: Color(0xFF633806))),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('Skip',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: cs.outline)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Permission note
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: 18, color: cs.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'We only send medicine reminders — no spam, no marketing.',
                    style: tt.bodySmall?.copyWith(
                        color: cs.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _NextButton(
            label: 'Allow notifications',
            onTap: () {
              // In real app: call flutter_local_notifications requestPermission()
              context.read<OnboardingCubit>().setNotificationsEnabled(true);
              onNext();
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: onNext,
              child: Text('Not now',
                  style: TextStyle(
                      color: cs.outline, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PAGE 6 — PREMIUM PAYWALL (free trial)
// ═══════════════════════════════════════════════════════════════

class _PremiumPage extends StatefulWidget {
  final VoidCallback onStart;
  final VoidCallback onSkip;

  const _PremiumPage({required this.onStart, required this.onSkip});

  @override
  State<_PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<_PremiumPage> {
  bool _yearlySelected = true;

  static const _perks = [
    (
      Icons.people_outline_rounded,
      'Unlimited family profiles',
      'Manage parents, children, spouse'
    ),
    (
      Icons.person_add_outlined,
      'Caregiver sharing & alerts',
      'Notify family on missed doses'
    ),
    (
      Icons.document_scanner_outlined,
      'OCR prescription scanning',
      'Auto-extract medicines from photos'
    ),
    (
      Icons.picture_as_pdf_outlined,
      'Export reports as PDF',
      'Share history with your doctor'
    ),
    (
      Icons.camera_alt_outlined,
      'AI medicine recognition',
      'Identify pills by photo'
    ),
    (Icons.block_outlined, 'Ad-free experience', 'No interruptions'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        // Hero header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
          ),
          child: Column(
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  size: 48, color: Color(0xFF0B6E6E)),
              const SizedBox(height: 10),
              BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (ctx, state) => Text(
                  state.userName != null
                      ? '${state.userName}, unlock\nfull MediTime'
                      : 'Unlock full\nMediTime',
                  style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onPrimaryContainer,
                      letterSpacing: -0.3),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '3-day free trial · cancel anytime',
                style: tt.bodySmall
                    ?.copyWith(color: cs.onPrimaryContainer.withOpacity(0.7)),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Column(
              children: [
                // Perks list
                ..._perks.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: cs.primaryContainer.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(p.$1, size: 18, color: cs.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.$2,
                                    style: tt.labelLarge?.copyWith(
                                        fontWeight: FontWeight.w700)),
                                Text(p.$3,
                                    style: tt.bodySmall
                                        ?.copyWith(color: cs.outline)),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle_rounded,
                              color: cs.primary, size: 20),
                        ],
                      ),
                    )),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Pricing toggle
                Row(
                  children: [
                    // Monthly
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _yearlySelected = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: !_yearlySelected
                                  ? cs.primary
                                  : cs.outlineVariant,
                              width: !_yearlySelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              Text('Monthly',
                                  style: tt.labelSmall
                                      ?.copyWith(color: cs.outline)),
                              const SizedBox(height: 4),
                              Text('৳99',
                                  style: tt.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w900)),
                              Text('/month',
                                  style: tt.bodySmall
                                      ?.copyWith(color: cs.outline)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Yearly
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _yearlySelected = true),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _yearlySelected
                                    ? cs.primaryContainer.withOpacity(0.3)
                                    : null,
                                border: Border.all(
                                  color: _yearlySelected
                                      ? cs.primary
                                      : cs.outlineVariant,
                                  width: _yearlySelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                children: [
                                  Text('Yearly',
                                      style: tt.labelSmall
                                          ?.copyWith(color: cs.outline)),
                                  const SizedBox(height: 4),
                                  Text('৳699',
                                      style: tt.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: cs.primary)),
                                  Text('৳58/month',
                                      style: tt.bodySmall
                                          ?.copyWith(color: cs.secondary)),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -12,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('40% off',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Bottom CTA
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    context.read<OnboardingCubit>().setPremium(true);
                    widget.onStart();
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Start 3-day free trial',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'No charge for 3 days. Cancel anytime.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.outline),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: widget.onSkip,
                child: Text('Continue with free plan',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SHARED HELPERS
// ═══════════════════════════════════════════════════════════════

class _PageHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PageHeader(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withOpacity(0.6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: cs.primary, size: 26),
        ),
        const SizedBox(height: 16),
        Text(title,
            style: tt.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                height: 1.15)),
        const SizedBox(height: 8),
        Text(subtitle,
            style: tt.bodyLarge
                ?.copyWith(color: cs.onSurfaceVariant, height: 1.5)),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NextButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
