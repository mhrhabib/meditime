import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/history/domain/entities/dose_log.dart';
import 'package:meditime/features/history/presentation/cubit/history_cubit.dart';
import 'package:meditime/features/medicines/presentation/screens/add_medicine_screen.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:meditime/features/medicines/presentation/cubit/medicine_cubit.dart';
import 'package:meditime/features/profile/presentation/screens/profile_setup_screen.dart';
import 'package:meditime/core/theme/app_theme.dart';
import 'package:meditime/core/widgets/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180.h,
            pinned: true,
            centerTitle: true,
            stretch: true,
            backgroundColor: cs.primary,
            elevation: 0,
            scrolledUnderElevation: 1,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cs.primary,
                      isDark ? const Color(0xFF004040) : const Color(0xFF0B8E8E),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 48.h, 20.w, 0),
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ProfileSwitcher(
                                    name: state.activeProfileName,
                                    initials: state.initials,
                                    profiles: state.profiles,
                                    onSwitch: (id) {
                                      if (id == 'add') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProfileSetupScreen(
                                              onComplete: () => Navigator.pop(context),
                                            ),
                                          ),
                                        );
                                      } else {
                                        context.read<ProfileCubit>().switchProfile(id);
                                        context.read<MedicineCubit>().setProfile(id);
                                      }
                                    },
                                  ),
                                  SizedBox(width: 8.w),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(alpha: 0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.emergency_rounded, color: Colors.white, size: 24.r),
                                          tooltip: 'Medical ID',
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content: Text('🚑 Emergency Medical ID Notification Active')),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24.r),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'Good morning, ${state.activeProfileName.split(' ').first}',
                              style: tt.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 24.sp,
                              ),
                            ),
                            Text(
                              '${DateTime.now().day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][DateTime.now().month - 1]} · ${context.read<MedicineCubit>().state.medicines.length} medicines today',
                              style: tt.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Main Content ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  BlocBuilder<MedicineCubit, MedicineState>(
                    builder: (context, medState) {
                      final lowStockCount =
                          medState.medicines.where((m) => m.isLowStock).length;
                      final totalScheduled = medState.medicines.length;

                      return BlocBuilder<HistoryCubit, HistoryState>(
                        builder: (context, historyState) {
                          final takenToday = historyState.events.where((e) {
                            final now = DateTime.now();
                            return e.status == DoseStatus.taken &&
                                e.dateTime.year == now.year &&
                                e.dateTime.month == now.month &&
                                e.dateTime.day == now.day;
                          }).length;

                          return Row(
                            children: [
                              Expanded(
                                child: StatCard(
                                  value: totalScheduled.toString(),
                                  label: 'Scheduled',
                                  containerColor:
                                      cs.primaryContainer.withValues(alpha: 0.4),
                                  contentColor: cs.primary,
                                  icon: Icons.calendar_today_rounded,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: StatCard(
                                  value: takenToday.toString(),
                                  label: 'Taken',
                                  containerColor:
                                      StatusColors.getTakenContainer(context),
                                  contentColor: StatusColors.getTaken(context),
                                  icon: Icons.check_circle_rounded,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: StatCard(
                                  value: lowStockCount.toString(),
                                  label: 'Low stock',
                                  containerColor:
                                      StatusColors.getLowStockContainer(context),
                                  contentColor:
                                      StatusColors.getLowStock(context),
                                  icon: Icons.inventory_2_rounded,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Calendar Strip
                  CalendarStrip(
                    onDateSelected: (date) {
                      // Filter logic for selected date
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Adherence card (real data)
                  BlocBuilder<HistoryCubit, HistoryState>(
                    builder: (context, historyState) {
                      final actionable =
                          historyState.takenCount + historyState.missedCount;
                      final pct = (historyState.adherenceRate * 100).round();
                      final headline = actionable == 0
                          ? 'Log your first dose to start tracking adherence.'
                          : 'You\'ve kept $pct% adherence this month.';
                      final sub = actionable == 0
                          ? 'Every dose you log helps build your history.'
                          : '${historyState.takenCount} taken · ${historyState.missedCount} missed';
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                              color: cs.outlineVariant.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('This month',
                                      style: tt.labelSmall?.copyWith(
                                          color: cs.primary,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                          fontSize: 10.sp)),
                                  SizedBox(height: 8.h),
                                  Text(headline,
                                      style: tt.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.sp)),
                                  SizedBox(height: 4.h),
                                  Text(sub,
                                      style: tt.bodySmall?.copyWith(
                                          color: cs.onSurfaceVariant,
                                          fontSize: 11.sp)),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: cs.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.trending_up_rounded,
                                  color: cs.primary, size: 28.r),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 32.h),

                  // Timeline
                  SectionHeader(
                      title: "Today's schedule",
                      action: 'See all',
                      onAction: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('See all medications')));
                      }),

                  BlocBuilder<MedicineCubit, MedicineState>(
                    builder: (context, state) {
                      if (state.medicines.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.medication_outlined, size: 48.r, color: cs.outlineVariant),
                                SizedBox(height: 12.h),
                                Text('No medicines scheduled today',
                                    style: tt.bodyMedium?.copyWith(color: cs.outline, fontSize: 14.sp)),
                                SizedBox(height: 24.h),
                                FilledButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (_) => const AddMedicineScreen()));
                                  },
                                  icon: Icon(Icons.add_rounded, size: 20.r),
                                  label: Text('Add your first medicine', style: TextStyle(fontSize: 14.sp)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return BlocBuilder<HistoryCubit, HistoryState>(
                        builder: (context, historyState) {
                          final now = DateTime.now();
                          final takenIdsToday = historyState.events
                              .where((e) =>
                                  e.status == DoseStatus.taken &&
                                  e.dateTime.year == now.year &&
                                  e.dateTime.month == now.month &&
                                  e.dateTime.day == now.day)
                              .map((e) => e.medicineId)
                              .toSet();

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: state.medicines.length,
                            itemBuilder: (context, index) {
                              final med = state.medicines[index];
                              final status = takenIdsToday.contains(med.id)
                                  ? MedicineStatus.taken
                                  : MedicineStatus.pending;

                              return MedicineTile(
                                time: med.schedule,
                                name: med.name,
                                dose: '1 ${med.type.toLowerCase()}',
                                instruction: '',
                                status: status,
                                onTake: () {
                                  context.read<MedicineCubit>().takeDose(med.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Logged dose: ${med.name}')),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 100.h), // Bottom nav space
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
