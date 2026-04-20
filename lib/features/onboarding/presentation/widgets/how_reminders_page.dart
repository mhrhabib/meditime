import 'package:flutter/material.dart';

import 'shared.dart';

class HowRemindersPage extends StatefulWidget {
  final VoidCallback onNext;
  const HowRemindersPage({super.key, required this.onNext});

  @override
  State<HowRemindersPage> createState() => _HowRemindersPageState();
}

class _HowRemindersPageState extends State<HowRemindersPage> {
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
                  const PageHeader(
                    icon: Icons.play_lesson_outlined,
                    title: 'How reminders\nwork',
                    subtitle: 'Simple 4-step setup. Done in under a minute.',
                  ),
                  const SizedBox(height: 24),
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
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(_activeStep),
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: step.color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: step.color.withValues(alpha: 0.25)),
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
                              ? cs.primaryContainer.withValues(alpha: 0.4)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: active
                                ? cs.primary.withValues(alpha: 0.3)
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
          NextButton(label: 'Got it — continue', onTap: widget.onNext),
        ],
      ),
    );
  }
}
