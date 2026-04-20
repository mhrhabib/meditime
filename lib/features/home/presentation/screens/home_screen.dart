import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/history/domain/entities/dose_log.dart';
import 'package:meditime/features/history/presentation/cubit/history_cubit.dart';
import 'package:meditime/features/home/presentation/widgets/adherence_summary.dart';
import 'package:meditime/features/home/presentation/widgets/calendar_strip.dart';
import 'package:meditime/features/home/presentation/widgets/elder_medicine_tile.dart';
import 'package:meditime/features/home/presentation/widgets/header_icon_button.dart';
import 'package:meditime/features/home/presentation/widgets/home_empty_state.dart';
import 'package:meditime/features/home/presentation/widgets/profile_switcher.dart';
import 'package:meditime/features/home/presentation/widgets/section_title.dart';
import 'package:meditime/features/home/presentation/widgets/today_summary.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';
import 'package:meditime/features/medicines/presentation/screens/add_medicine_screen.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:meditime/features/medicines/presentation/cubit/medicine_cubit.dart';
import 'package:meditime/features/profile/presentation/screens/profile_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<DoseEvent> _getDoseEvents(
      List<Medicine> medicines, List<DoseLog> logs, DateTime date) {
    final List<DoseEvent> events = [];

    for (final med in medicines) {
      // Fallback for legacy medicines without times
      final times =
          med.times.isEmpty ? [const TimeOfDay(hour: 8, minute: 0)] : med.times;

      for (final time in times) {
        final scheduledDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        final isTaken = logs.any((log) =>
            log.medicineId == med.id &&
            log.status == DoseStatus.taken &&
            log.scheduledDateTime != null &&
            log.scheduledDateTime!.year == scheduledDateTime.year &&
            log.scheduledDateTime!.month == scheduledDateTime.month &&
            log.scheduledDateTime!.day == scheduledDateTime.day &&
            log.scheduledDateTime!.hour == scheduledDateTime.hour &&
            log.scheduledDateTime!.minute == scheduledDateTime.minute);

        events.add(DoseEvent(
          medicine: med,
          scheduledTime: time,
          isTaken: isTaken,
          scheduledDateTime: scheduledDateTime,
        ));
      }
    }

    // Sort by time
    events.sort((a, b) {
      final aVal = a.scheduledTime.hour * 60 + a.scheduledTime.minute;
      final bVal = b.scheduledTime.hour * 60 + b.scheduledTime.minute;
      return aVal.compareTo(bVal);
    });

    return events;
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            toolbarHeight: 64.h,
            backgroundColor: cs.surface,
            surfaceTintColor: cs.surface,
            elevation: 0,
            scrolledUnderElevation: 3,
            shadowColor: cs.shadow.withValues(alpha: 0.08),
            automaticallyImplyLeading: false,
            titleSpacing: 16.w,
            title: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return ProfileSwitcher(
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
                );
              },
            ),
            actions: [
              HeaderIconButton(
                icon: Icons.emergency_rounded,
                background: Colors.red.withValues(alpha: 0.12),
                iconColor: Colors.red.shade700,
                tooltip: 'Medical ID',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            '🚑 Emergency Medical ID Notification Active')),
                  );
                },
              ),
              SizedBox(width: 8.w),
              HeaderIconButton(
                icon: Icons.notifications_none_rounded,
                background: cs.surfaceContainerHighest,
                iconColor: cs.onSurface,
                onPressed: () {},
              ),
              SizedBox(width: 12.w),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final firstName = state.activeProfileName.split(' ').first;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${_greeting()},',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        firstName,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.r, 0, 16.r, 0),
              child: BlocBuilder<MedicineCubit, MedicineState>(
                builder: (context, medState) {
                  return BlocBuilder<HistoryCubit, HistoryState>(
                    builder: (context, historyState) {
                      final now = DateTime.now();
                      final today = DateTime(now.year, now.month, now.day);

                      final allEvents = _getDoseEvents(
                        medState.medicines,
                        historyState.events,
                        today,
                      );

                      final pending =
                          allEvents.where((e) => !e.isTaken).toList();
                      final taken = allEvents.where((e) => e.isTaken).toList();

                      if (medState.medicines.isEmpty) {
                        return HomeEmptyState(
                          onAdd: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddMedicineScreen()),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TodaySummary(
                            pendingCount: pending.length,
                            takenCount: taken.length,
                          ),
                          SizedBox(height: 20.h),
                          CalendarStrip(
                            onDateSelected: (_) {},
                          ),
                          SizedBox(height: 20.h),
                          if (pending.isNotEmpty) ...[
                            const SectionTitle(
                              title: 'Up next',
                              subtitle:
                                  'Tap the big green button when you take it',
                            ),
                            SizedBox(height: 12.h),
                            ...pending.map((event) => ElderMedicineTile(
                                  time: event.scheduledTime.format(context),
                                  name: event.medicine.name,
                                  dose:
                                      '${event.medicine.amount % 1 == 0 ? event.medicine.amount.toInt() : event.medicine.amount} ${event.medicine.type.toLowerCase()}${event.medicine.strength != null && event.medicine.strength!.isNotEmpty ? ' · ${event.medicine.strength}${event.medicine.unit ?? ''}' : ''}',
                                  imagePath: event.medicine.imagePath,
                                  status: MedicineStatus.pending,
                                  onTake: () {
                                    context.read<MedicineCubit>().takeDose(
                                          event.medicine.id,
                                          scheduledTime:
                                              event.scheduledDateTime,
                                        );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Logged: ${event.medicine.name}',
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  onSkip: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Skipped: ${event.medicine.name}',
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ],
                          if (taken.isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            const SectionTitle(title: 'Already taken'),
                            SizedBox(height: 12.h),
                            ...taken.map((event) => ElderMedicineTile(
                                  time: event.scheduledTime.format(context),
                                  name: event.medicine.name,
                                  dose:
                                      '${event.medicine.amount % 1 == 0 ? event.medicine.amount.toInt() : event.medicine.amount} ${event.medicine.type.toLowerCase()}${event.medicine.strength != null && event.medicine.strength!.isNotEmpty ? ' · ${event.medicine.strength}${event.medicine.unit ?? ''}' : ''}',
                                  imagePath: event.medicine.imagePath,
                                  status: MedicineStatus.taken,
                                )),
                          ],
                          SizedBox(height: 24.h),
                          AdherenceSummary(historyState: historyState),
                          SizedBox(height: 120.h),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DoseEvent {
  final Medicine medicine;
  final TimeOfDay scheduledTime;
  final bool isTaken;
  final DateTime scheduledDateTime;

  DoseEvent({
    required this.medicine,
    required this.scheduledTime,
    required this.isTaken,
    required this.scheduledDateTime,
  });
}
