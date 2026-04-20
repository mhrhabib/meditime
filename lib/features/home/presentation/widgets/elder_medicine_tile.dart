import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/core/theme/app_theme.dart';

enum MedicineStatus { taken, missed, pending }

class ElderMedicineTile extends StatelessWidget {
  final String time;
  final String name;
  final String dose;
  final String? imagePath;
  final MedicineStatus status;
  final VoidCallback? onTake;
  final VoidCallback? onSkip;

  const ElderMedicineTile({
    super.key,
    required this.time,
    required this.name,
    required this.dose,
    this.imagePath,
    required this.status,
    this.onTake,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPending = status == MedicineStatus.pending;
    final isTaken = status == MedicineStatus.taken;
    final isMissed = status == MedicineStatus.missed;

    final accent = isTaken
        ? StatusColors.getTaken(context)
        : isMissed
            ? StatusColors.getMissed(context)
            : cs.primary;
    final accentContainer = isTaken
        ? StatusColors.getTakenContainer(context)
        : isMissed
            ? StatusColors.getMissedContainer(context)
            : cs.primaryContainer.withValues(alpha: 0.4);

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isPending ? accent.withValues(alpha: 0.4) : accent.withValues(alpha: 0.25),
          width: isPending ? 2.w : 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : const Color(0x14000000),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (imagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    File(imagePath!),
                    width: 50.r,
                    height: 50.r,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: accentContainer,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time_rounded, size: 22.r, color: accent),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          time,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isTaken || isMissed) SizedBox(width: 10.w),
              if (isTaken)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 26.r, color: accent),
                    SizedBox(width: 6.w),
                    Text(
                      'Taken',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                  ],
                )
              else if (isMissed)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cancel_rounded, size: 26.r, color: accent),
                    SizedBox(width: 6.w),
                    Text(
                      'Missed',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: accent,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
              height: 1.2,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            dose,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
            ),
          ),
          if (isPending) ...[
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 60.h,
                    child: FilledButton.icon(
                      onPressed: onTake,
                      style: FilledButton.styleFrom(
                        backgroundColor: StatusColors.getTaken(context),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      icon: Icon(Icons.check_rounded, size: 26.r),
                      label: Text(
                        'TAKE NOW',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 60.h,
                    child: OutlinedButton(
                      onPressed: onSkip,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.onSurfaceVariant,
                        side: BorderSide(color: cs.outlineVariant, width: 1.5.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
