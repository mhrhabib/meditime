import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/core/widgets/components.dart';
import 'package:meditime/features/emergency_card/presentation/cubit/emergency_card_cubit.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => EmergencyCardCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Emergency Card', style: TextStyle(fontSize: 20.sp)),
          centerTitle: false,
          actions: [
            IconButton(
                icon: Icon(Icons.edit_note_rounded, size: 24.r), onPressed: () {}),
            SizedBox(width: 8.w),
          ],
        ),
        body: BlocBuilder<EmergencyCardCubit, EmergencyCardState>(
          builder: (context, state) {
            final card = state.card;
            if (card == null) {
              return _EmergencyEmptyState(onSetup: () {});
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  EmergencyCardWidget(
                    name: card.fullName,
                    age: '',
                    bloodGroup: card.bloodType,
                    allergies: card.allergies
                        .split(',')
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .toList(),
                    conditions: card.conditions
                        .split(',')
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .toList(),
                    medicines: const [],
                    emergencyContact:
                        '${card.emergencyContactName} — ${card.emergencyContactPhone}',
                    lastUpdated: 'Updated today',
                  ),
                  SizedBox(height: 20.h),

                  // Scannable QR section
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                          color: cs.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 72.r,
                          height: 72.r,
                          decoration: BoxDecoration(
                            color: cs.onSurface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Icon(Icons.qr_code_2_rounded,
                              size: 40.r, color: cs.primary),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Scannable without app',
                                  style: tt.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w800, fontSize: 13.sp)),
                              SizedBox(height: 4.h),
                              Text(
                                  'First responders scan this QR to see your card — no phone unlock needed.',
                                  style: tt.bodySmall
                                      ?.copyWith(color: cs.onSurfaceVariant, fontSize: 11.sp)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Persistent Notification Toggle
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: state.isPersistentNotificationEnabled 
                        ? cs.primaryContainer.withValues(alpha: 0.3)
                        : cs.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Lock Screen Access', 
                        style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp)),
                      subtitle: Text('Keep your vital info visible in the notification shade even while locked.',
                        style: tt.bodySmall?.copyWith(fontSize: 12.sp)),
                      value: state.isPersistentNotificationEnabled,
                      onChanged: (val) {
                        context.read<EmergencyCardCubit>().updatePersistentNotification(val);
                        
                        if (val) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✅ Persistent Emergency Notification Enabled')),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),

                  AlertBanner(
                    message:
                        'Enabled "Lock Screen Access" so first responders can find this without unlocking your phone.',
                    type: AlertType.warning,
                    actionLabel: 'Details',
                    onAction: () {},
                  ),

                  SizedBox(height: 32.h),

                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<EmergencyCardCubit>().exportPdf();
                    },
                    icon: Icon(Icons.share_rounded, size: 18.r),
                    label: Text('Export Card as PDF', style: TextStyle(fontSize: 14.sp)),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 56.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r)),
                    ),
                  ),
                  SizedBox(height: 48.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EmergencyEmptyState extends StatelessWidget {
  final VoidCallback onSetup;

  const _EmergencyEmptyState({required this.onSetup});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_information_outlined,
                size: 64.r, color: cs.outlineVariant),
            SizedBox(height: 16.h),
            Text(
              'No emergency card yet',
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Set up your medical ID so first responders can access vital info in an emergency.',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 20.h),
            FilledButton.icon(
              onPressed: onSetup,
              icon: Icon(Icons.add_rounded, size: 18.r),
              label:
                  Text('Set up card', style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }
}
