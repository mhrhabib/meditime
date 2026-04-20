import 'package:flutter/material.dart';

import 'shared.dart';

class BenefitsPage extends StatelessWidget {
  final VoidCallback onNext;
  const BenefitsPage({super.key, required this.onNext});

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
          const PageHeader(
            icon: Icons.star_outline_rounded,
            title: 'Why MediTime\nworks',
            subtitle: 'Built around real reasons people miss their medicines.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _benefits.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final b = _benefits[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (b.$4).withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: (b.$4).withValues(alpha: 0.2)),
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
          NextButton(label: 'Enable reminders', onTap: onNext),
        ],
      ),
    );
  }
}
