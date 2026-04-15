import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:meditime/features/medicines/presentation/cubit/medicine_cubit.dart';
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
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            // title: const Text('MediTime'),
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
                      isDark
                          ? const Color(0xFF004040)
                          : const Color(0xFF0B8E8E),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ProfileSwitcher(
                                  name: state.activeProfileName,
                                  initials: state.initials,
                                  dependents: state.dependents,
                                  onTap: () {},
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.notifications_none_rounded,
                                        color: Colors.white),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Good morning, ${state.activeProfileName.split(' ').first}',
                              style: tt.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Saturday, 14 March · 3 medicines today',
                              style: tt.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.85),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stat cards
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          value: '3',
                          label: 'Remaining',
                          containerColor: cs.primaryContainer,
                          contentColor: cs.onPrimaryContainer,
                          icon: Icons.medication_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          value: '2',
                          label: 'Taken',
                          containerColor:
                              StatusColors.getTakenContainer(context),
                          contentColor: StatusColors.getTaken(context),
                          icon: Icons.check_circle_rounded,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          value: '1',
                          label: 'Low stock',
                          containerColor:
                              StatusColors.getLowStockContainer(context),
                          contentColor: StatusColors.getLowStock(context),
                          icon: Icons.inventory_2_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Alert banner
                  AlertBanner(
                    message: 'Paracetamol stock low — 3 days left',
                    type: AlertType.warning,
                    actionLabel: 'Refill',
                    onAction: () {},
                  ),
                  const SizedBox(height: 24),

                  // Timeline
                  SectionHeader(
                      title: "Today's schedule",
                      action: 'See all',
                      onAction: () {}),

                  BlocBuilder<MedicineCubit, MedicineState>(
                    builder: (context, state) {
                      if (state.medicines.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.medication_outlined,
                                    size: 48, color: cs.outlineVariant),
                                const SizedBox(height: 12),
                                Text('No medicines scheduled today',
                                    style: tt.bodyMedium
                                        ?.copyWith(color: cs.outline)),
                                const SizedBox(height: 24),
                                FilledButton.icon(
                                  onPressed: () {}, // TODO: Navigate to add med
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('Add your first medicine'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.medicines.length,
                        itemBuilder: (context, index) {
                          final med = state.medicines[index];
                          MedicineStatus status = MedicineStatus.pending;
                          if (med.name.contains('Metformin'))
                            status = MedicineStatus.taken;
                          if (med.name.contains('Amlodipine'))
                            status = MedicineStatus.missed;

                          return MedicineTile(
                            time: '8:00 AM',
                            name: med.name,
                            dose: '1 ${med.type}',
                            instruction: med.schedule.split('·').last.trim(),
                            status: status,
                            onTake:
                                status == MedicineStatus.pending ? () {} : null,
                            onSkip:
                                status == MedicineStatus.pending ? () {} : null,
                            onSnooze:
                                status == MedicineStatus.pending ? () {} : null,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Weekly streak
                  const SectionHeader(title: 'This week performance'),
                  const StreakRow(
                    days: [
                      StreakDay('M', DayStatus.taken),
                      StreakDay('T', DayStatus.taken),
                      StreakDay('W', DayStatus.missed),
                      StreakDay('T', DayStatus.taken),
                      StreakDay('F', DayStatus.taken),
                      StreakDay('S', DayStatus.partial),
                      StreakDay('S', DayStatus.future),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
