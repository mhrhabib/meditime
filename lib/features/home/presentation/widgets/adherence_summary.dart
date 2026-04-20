import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/history/presentation/cubit/history_cubit.dart';

class AdherenceSummary extends StatelessWidget {
  final HistoryState historyState;
  const AdherenceSummary({super.key, required this.historyState});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final actionable = historyState.takenCount + historyState.missedCount;
    final pct = (historyState.adherenceRate * 100).round();
    final headline = actionable == 0
        ? 'Log your first dose to start tracking.'
        : '$pct% adherence this month';
    final sub = actionable == 0
        ? 'Every dose you log builds your history.'
        : '${historyState.takenCount} taken · ${historyState.missedCount} missed';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.trending_up_rounded, color: cs.primary, size: 30.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This month',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  headline,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  sub,
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
    );
  }
}
