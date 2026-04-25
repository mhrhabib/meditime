import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/core/theme/app_theme.dart';

class TodaySummary extends StatelessWidget {
  final int pendingCount;
  final int takenCount;
  final int missedCount;
  const TodaySummary({
    super.key,
    required this.pendingCount,
    required this.takenCount,
    this.missedCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final takenColor = StatusColors.getTaken(context);
    final takenBg = StatusColors.getTakenContainer(context);
    final pendingColor = cs.primary;
    final pendingBg = cs.primaryContainer.withValues(alpha: 0.5);
    final missedColor = StatusColors.getMissed(context);
    final missedBg = StatusColors.getMissedContainer(context);

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            value: pendingCount.toString(),
            label: pendingCount == 1 ? 'dose left' : 'doses left',
            icon: Icons.schedule_rounded,
            color: pendingColor,
            bg: pendingBg,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _SummaryCard(
            value: takenCount.toString(),
            label: 'taken',
            icon: Icons.check_circle_rounded,
            color: takenColor,
            bg: takenBg,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _SummaryCard(
            value: missedCount.toString(),
            label: 'missed',
            icon: Icons.cancel_rounded,
            color: missedColor,
            bg: missedBg,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;

  const _SummaryCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22.r, color: color),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
