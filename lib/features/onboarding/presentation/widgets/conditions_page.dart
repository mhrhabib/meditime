import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/features/onboarding/presentation/cubit/onboarding_cubit.dart';

import 'shared.dart';

class ConditionsPage extends StatefulWidget {
  final VoidCallback onNext;
  const ConditionsPage({super.key, required this.onNext});

  @override
  State<ConditionsPage> createState() => _ConditionsPageState();
}

class _ConditionsPageState extends State<ConditionsPage> {
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
          const PageHeader(
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
                  if (isSelected) {
                    _selected.remove(c.$1);
                  } else {
                    _selected.add(c.$1);
                  }
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
          NextButton(
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
