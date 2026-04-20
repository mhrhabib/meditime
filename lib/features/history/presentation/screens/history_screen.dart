import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/core/theme/app_theme.dart';
import 'package:meditime/core/widgets/components.dart';
import 'package:meditime/features/history/presentation/cubit/history_cubit.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: Text('History & Stats', style: TextStyle(fontSize: 20.sp)),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf_rounded, size: 24.r),
              onPressed: () {
                final profileName = context.read<ProfileCubit>().state.activeProfileName;
                context.read<HistoryCubit>().exportPdfReport(profileName);
              },
            ),
            IconButton(
              icon: Icon(Icons.calendar_month_outlined, size: 24.r),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Time Period Toggle ──────────────────────────────────
                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.read<HistoryCubit>().setFilter(HistoryFilter.month),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: state.filter == HistoryFilter.month ? cs.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: state.filter == HistoryFilter.month
                                    ? [
                                        BoxShadow(
                                          color: cs.primary.withValues(alpha: 0.3),
                                          blurRadius: 8.r,
                                          offset: Offset(0, 2.h),
                                        ),
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: Text('This month',
                                  style: TextStyle(
                                      color: state.filter == HistoryFilter.month ? Colors.white : cs.onSurfaceVariant,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13.sp)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.read<HistoryCubit>().setFilter(HistoryFilter.all),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: state.filter == HistoryFilter.all ? cs.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: state.filter == HistoryFilter.all
                                    ? [
                                        BoxShadow(
                                          color: cs.primary.withValues(alpha: 0.3),
                                          blurRadius: 8.r,
                                          offset: Offset(0, 2.h),
                                        ),
                                      ]
                                    : [],
                              ),
                              alignment: Alignment.center,
                              child: Text('All time',
                                  style: TextStyle(
                                      color: state.filter == HistoryFilter.all ? Colors.white : cs.onSurfaceVariant,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13.sp)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // ── Key Stats ──────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: '${(state.adherenceRate * 100).toInt()}%',
                          label: 'Adherence',
                          icon: Icons.analytics_rounded,
                          containerColor: cs.primaryContainer.withValues(alpha: 0.6),
                          contentColor: cs.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: StatCard(
                          value: state.takenCount.toString(),
                          label: 'Taken',
                          icon: Icons.check_circle_rounded,
                          containerColor: StatusColors.getTakenContainer(context),
                          contentColor: StatusColors.getTaken(context),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: StatCard(
                          value: state.missedCount.toString(),
                          label: 'Missed',
                          icon: Icons.cancel_rounded,
                          containerColor: StatusColors.getMissedContainer(context),
                          contentColor: StatusColors.getMissed(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // ── Per-medicine adherence ──────────────────────────────
                  const SectionHeader(title: 'Per-medicine adherence'),
                  SizedBox(height: 8.h),
                  if (state.perMedicineAdherence.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(
                        child: Text('No data yet', style: TextStyle(color: cs.outlineVariant, fontSize: 14.sp)),
                      ),
                    )
                  else
                    ...state.perMedicineAdherence.entries.map((e) => _buildAdherenceBar(context, e.key, e.value)),

                  SizedBox(height: 32.h),

                  SizedBox(height: 48.h),
                ],
              ),
            );
          },
        ),
    );
  }

  Widget _buildAdherenceBar(BuildContext context, String name, double percentage) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp)),
              Text('${(percentage * 100).toInt()}%',
                  style: TextStyle(color: cs.primary, fontWeight: FontWeight.w800, fontSize: 13.sp)),
            ],
          ),
          SizedBox(height: 10.h),
          Stack(
            children: [
              Container(
                height: 10.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage.clamp(0.01, 1.0),
                child: Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.secondary],
                    ),
                    borderRadius: BorderRadius.circular(5.r),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
