import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'shared.dart';

class SetupCompletePage extends StatefulWidget {
  final VoidCallback onNext;
  final String name;
  const SetupCompletePage(
      {super.key, required this.onNext, required this.name});

  @override
  State<SetupCompletePage> createState() => _SetupCompletePageState();
}

class _SetupCompletePageState extends State<SetupCompletePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final name = widget.name.isNotEmpty ? widget.name : 'there';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1.04).animate(
                    CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                  ),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 56, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  "You're all set,\n$name!",
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Here's what your first reminder will look like.",
                  style: tt.bodyMedium
                      ?.copyWith(color: cs.onSurfaceVariant, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(18),
                    border:
                        Border.all(color: cs.primary.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.medication_rounded,
                                color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('MediTime',
                                    style: tt.labelMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: cs.primary)),
                                Text(
                                  'Time to take your medicine',
                                  style: tt.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Text('8:00 AM',
                              style:
                                  tt.labelSmall?.copyWith(color: cs.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _TickRow(text: 'Reminders set up'),
                const _TickRow(text: 'Health profile saved'),
                const _TickRow(text: 'Ready to add your first medicine'),
              ],
            ),
          ),
          NextButton(
            label: 'Continue',
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onNext();
            },
          ),
        ],
      ),
    );
  }
}

class _TickRow extends StatelessWidget {
  final String text;
  const _TickRow({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: cs.primary, size: 18),
          const SizedBox(width: 10),
          Text(text,
              style: tt.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
