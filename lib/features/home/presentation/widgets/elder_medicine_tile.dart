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
  final bool isOverdue;
  final String? overdueLabel;
  final bool isLowStock;
  final int? daysLeft;
  final bool isLockedEarly;
  final String? lockedHint;
  final VoidCallback? onTake;
  final VoidCallback? onSkip;
  final VoidCallback? onSnooze;
  final VoidCallback? onTakeEarly;

  const ElderMedicineTile({
    super.key,
    required this.time,
    required this.name,
    required this.dose,
    this.imagePath,
    required this.status,
    this.isOverdue = false,
    this.overdueLabel,
    this.isLowStock = false,
    this.daysLeft,
    this.isLockedEarly = false,
    this.lockedHint,
    this.onTake,
    this.onSkip,
    this.onSnooze,
    this.onTakeEarly,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPending = status == MedicineStatus.pending;
    final isTaken = status == MedicineStatus.taken;
    final isMissed = status == MedicineStatus.missed;

    final showOverdue = isPending && isOverdue;
    final accent = isTaken
        ? StatusColors.getTaken(context)
        : (isMissed || showOverdue)
            ? StatusColors.getMissed(context)
            : cs.primary;
    final accentContainer = isTaken
        ? StatusColors.getTakenContainer(context)
        : (isMissed || showOverdue)
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
              Container(
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
                    Text(
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
                  ],
                ),
              ),
              const Spacer(),
              if (isPending && !showOverdue && !isLockedEarly && onSnooze != null)
                IconButton(
                  onPressed: onSnooze,
                  tooltip: 'Snooze',
                  iconSize: 26.r,
                  padding: EdgeInsets.all(6.r),
                  constraints: BoxConstraints.tightFor(width: 44.r, height: 44.r),
                  icon: Icon(Icons.snooze_rounded, color: cs.onSurfaceVariant),
                ),
              if (isTaken || isMissed || showOverdue) SizedBox(width: 10.w),
              if (showOverdue)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 24.r, color: accent),
                    SizedBox(width: 4.w),
                    Text(
                      overdueLabel ?? 'OVERDUE',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: accent,
                      ),
                    ),
                  ],
                )
              else if (isTaken)
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
          Row(
            children: [
              Flexible(
                child: Text(
                  dose,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),
              if (isLowStock) ...[
                SizedBox(width: 8.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.5),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory_2_rounded,
                          size: 14.r, color: Colors.orange.shade800),
                      SizedBox(width: 4.w),
                      Text(
                        daysLeft != null
                            ? '${daysLeft!}d left'
                            : 'Low stock',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (isPending && isLockedEarly) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: cs.outlineVariant.withValues(alpha: 0.6),
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_clock_rounded,
                      size: 22.r, color: cs.onSurfaceVariant),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      lockedHint ?? 'Available at $time',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (onTakeEarly != null)
                    TextButton(
                      onPressed: onTakeEarly,
                      style: TextButton.styleFrom(
                        foregroundColor: cs.primary,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Take early',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ] else if (isPending) ...[
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
