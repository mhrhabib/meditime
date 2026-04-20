import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/notifications/notification_service.dart';
import 'package:meditime/features/onboarding/presentation/cubit/onboarding_cubit.dart';

import 'shared.dart';

class NotificationsPage extends StatelessWidget {
  final VoidCallback onNext;
  const NotificationsPage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
      child: Column(
        children: [
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
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withValues(alpha: 0.3),
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
          NextButton(
            label: 'Allow notifications',
            onTap: () async {
              HapticFeedback.lightImpact();
              final cubit = context.read<OnboardingCubit>();
              final messenger = ScaffoldMessenger.maybeOf(context);

              final notifOk =
                  await NotificationService.instance.requestPermission();
              final alarmOk = await NotificationService.instance
                  .requestExactAlarmsPermission();
              await cubit.setNotificationsEnabled(notifOk);

              if (!notifOk && messenger != null) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Notifications denied. You can enable them later in Settings.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              } else if (notifOk && !alarmOk && messenger != null) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Heads up: exact alarms are disabled — reminders may be delayed.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }

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
