import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';

class MedicalIdSheet extends StatelessWidget {
  final String profileName;
  final List<Medicine> medicines;

  const MedicalIdSheet({
    super.key,
    required this.profileName,
    required this.medicines,
  });

  static Future<void> show(
    BuildContext context, {
    required String profileName,
    required List<Medicine> medicines,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MedicalIdSheet(
        profileName: profileName,
        medicines: medicines,
      ),
    );
  }

  String _doseLine(Medicine m) {
    final amount = m.amount % 1 == 0 ? m.amount.toInt() : m.amount;
    final strength =
        (m.strength != null && m.strength!.isNotEmpty) ? ' ${m.strength}${m.unit ?? ''}' : '';
    return '$amount ${m.type.toLowerCase()}$strength';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 44.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(Icons.emergency_rounded,
                        color: Colors.red.shade700, size: 26.r),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medical ID',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          profileName,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView(
                controller: controller,
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                children: [
                  const _SectionHeader(title: 'Current medicines'),
                  SizedBox(height: 8.h),
                  if (medicines.isEmpty)
                    Text(
                      'No medicines on file.',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15.sp,
                        color: cs.onSurfaceVariant,
                      ),
                    )
                  else
                    ...medicines.map((m) => Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: cs.outlineVariant.withValues(alpha: 0.5),
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.medication_rounded,
                                  color: cs.primary, size: 22.r),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m.name,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w800,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    Text(
                                      _doseLine(m),
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  SizedBox(height: 20.h),
                  const _SectionHeader(title: 'Emergency info'),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: cs.tertiaryContainer.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Text(
                      'Add blood type, allergies, conditions, and emergency contacts in profile settings so responders can see them here.',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Nunito',
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        color: cs.onSurface,
      ),
    );
  }
}
