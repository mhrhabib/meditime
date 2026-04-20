import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/core/theme/app_theme.dart';

class TodaySummary extends StatelessWidget {
  final int pendingCount;
  final int takenCount;
  const TodaySummary({
    super.key,
    required this.pendingCount,
    required this.takenCount,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final takenColor = StatusColors.getTaken(context);
    final takenBg = StatusColors.getTakenContainer(context);
    final pendingColor = cs.primary;
    final pendingBg = cs.primaryContainer.withValues(alpha: 0.5);

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
        SizedBox(width: 12.w),
        Expanded(
          child: _SummaryCard(
            value: takenCount.toString(),
            label: 'taken today',
            icon: Icons.check_circle_rounded,
            color: takenColor,
            bg: takenBg,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32.r, color: color),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w800,
                    color: color,
                    height: 1,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: color.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
