import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meditime/features/history/domain/entities/dose_log.dart';
import 'package:meditime/features/history/presentation/cubit/history_cubit.dart';
import 'package:meditime/features/home/presentation/widgets/adherence_summary.dart';
import 'package:meditime/features/home/presentation/widgets/calendar_strip.dart';
import 'package:meditime/features/home/presentation/widgets/elder_medicine_tile.dart';
import 'package:meditime/features/home/presentation/widgets/header_icon_button.dart';
import 'package:meditime/features/home/presentation/widgets/home_empty_state.dart';
import 'package:meditime/features/home/presentation/widgets/medical_id_sheet.dart';
import 'package:meditime/features/home/presentation/widgets/next_dose_banner.dart';
import 'package:meditime/features/home/presentation/widgets/profile_switcher.dart';
import 'package:meditime/features/home/presentation/widgets/section_title.dart';
import 'package:meditime/features/home/presentation/widgets/today_summary.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';
import 'package:meditime/features/medicines/presentation/screens/add_medicine_screen.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:meditime/features/medicines/presentation/cubit/medicine_cubit.dart';
import 'package:meditime/features/profile/presentation/screens/profile_setup_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<DoseEvent> _getDoseEvents(
      List<Medicine> medicines, List<DoseLog> logs, DateTime date) {
    final List<DoseEvent> events = [];

    for (final med in medicines) {
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

        bool matchesSlot(DoseLog log) =>
            log.medicineId == med.id &&
            log.scheduledDateTime != null &&
            log.scheduledDateTime!.year == scheduledDateTime.year &&
            log.scheduledDateTime!.month == scheduledDateTime.month &&
            log.scheduledDateTime!.day == scheduledDateTime.day &&
            log.scheduledDateTime!.hour == scheduledDateTime.hour &&
            log.scheduledDateTime!.minute == scheduledDateTime.minute;

        final isTaken =
            logs.any((l) => matchesSlot(l) && l.status == DoseStatus.taken);
        final isSkipped =
            logs.any((l) => matchesSlot(l) && l.status == DoseStatus.skipped);

        events.add(DoseEvent(
          medicine: med,
          scheduledTime: time,
          isTaken: isTaken,
          isSkipped: isSkipped,
          scheduledDateTime: scheduledDateTime,
        ));
      }
    }

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

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  static const Duration _earlyWindow = Duration(minutes: 60);

  String _hoursMinutesUntil(DateTime target) {
    final diff = target.difference(DateTime.now());
    if (diff.isNegative) return 'now';
    final hours = diff.inHours;
    final minutes = diff.inMinutes - hours * 60;
    if (hours == 0) return 'in $minutes min';
    if (minutes == 0) return 'in $hours hr';
    return 'in $hours hr $minutes min';
  }

  Future<bool> _confirmTakeEarly(
      BuildContext context, DoseEvent event) async {
    final scheduled = TimeOfDay.fromDateTime(event.scheduledDateTime)
        .format(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Take this dose early?'),
        content: Text(
          '${event.medicine.name} is scheduled for $scheduled '
          '(${_hoursMinutesUntil(event.scheduledDateTime)}). '
          'Logging it now will mark this dose as taken and reduce stock.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Take early'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _toast(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 15,
    );
  }

  void _logTakeWithUndo(BuildContext context, DoseEvent event) {
    final cubit = context.read<MedicineCubit>();
    cubit.takeDose(event.medicine.id, scheduledTime: event.scheduledDateTime);
    _toast('Logged: ${event.medicine.name}');
  }

  Future<void> _logSkipWithUndo(BuildContext context, DoseEvent event) async {
    final cubit = context.read<MedicineCubit>();
    await cubit.skipDose(event.medicine.id,
        scheduledTime: event.scheduledDateTime);
    _toast('Skipped: ${event.medicine.name}');
  }

  Future<void> _handleTakeEarly(
      BuildContext context, DoseEvent event) async {
    final confirmed = await _confirmTakeEarly(context, event);
    if (!confirmed || !context.mounted) return;
    _logTakeWithUndo(context, event);
  }

  Future<void> _showSnoozeSheet(
      BuildContext context, DoseEvent event) async {
    final cs = Theme.of(context).colorScheme;
    final cubit = context.read<MedicineCubit>();

    final delay = await showModalBottomSheet<Duration>(
      context: context,
      backgroundColor: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Snooze ${event.medicine.name}',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              SizedBox(height: 16.h),
              for (final minutes in const [10, 30, 60])
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: SizedBox(
                    height: 56.h,
                    child: FilledButton.tonalIcon(
                      onPressed: () => Navigator.pop(
                          ctx, Duration(minutes: minutes)),
                      icon: Icon(Icons.snooze_rounded, size: 22.r),
                      label: Text(
                        minutes < 60
                            ? 'Remind me in $minutes min'
                            : 'Remind me in 1 hour',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (delay == null) return;
    await cubit.snoozeDose(
      event.medicine.id,
      scheduledTime: event.scheduledDateTime,
      delay: delay,
    );
    _toast('Snoozed ${event.medicine.name} for ${delay.inMinutes} min');
  }

  String _dateLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = _selectedDate.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == -1) return 'Yesterday';
    if (diff == 1) return 'Tomorrow';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[_selectedDate.month - 1]} ${_selectedDate.day}';
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
                  final profileName =
                      context.read<ProfileCubit>().state.activeProfileName;
                  final meds =
                      context.read<MedicineCubit>().state.medicines;
                  MedicalIdSheet.show(
                    context,
                    profileName: profileName,
                    medicines: meds,
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
                      final allEvents = _getDoseEvents(
                        medState.medicines,
                        historyState.events,
                        _selectedDate,
                      );

                      final now = DateTime.now();
                      final pendingAll = allEvents
                          .where((e) => !e.isTaken && !e.isSkipped)
                          .toList();
                      final overdue = _isToday
                          ? pendingAll
                              .where((e) =>
                                  e.scheduledDateTime.isBefore(now))
                              .toList()
                          : <DoseEvent>[];
                      final upcoming = _isToday
                          ? pendingAll
                              .where((e) =>
                                  !e.scheduledDateTime.isBefore(now))
                              .toList()
                          : pendingAll;
                      final pending = [...overdue, ...upcoming];
                      final taken = allEvents.where((e) => e.isTaken).toList();
                      final skipped =
                          allEvents.where((e) => e.isSkipped).toList();
                      final nextDose =
                          _isToday && upcoming.isNotEmpty ? upcoming.first : null;

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
                            onDateSelected: (date) {
                              setState(() {
                                _selectedDate = DateTime(
                                    date.year, date.month, date.day);
                              });
                            },
                          ),
                          SizedBox(height: 20.h),
                          if (nextDose != null &&
                              nextDose.scheduledDateTime
                                      .difference(now) <=
                                  _earlyWindow)
                            NextDoseBanner(
                              medicine: nextDose.medicine,
                              scheduledDateTime: nextDose.scheduledDateTime,
                              onTake: () =>
                                  _logTakeWithUndo(context, nextDose),
                            ),
                          if (pending.isNotEmpty) ...[
                            SectionTitle(
                              title: _isToday
                                  ? (overdue.isNotEmpty
                                      ? 'Overdue & upcoming'
                                      : 'Up next')
                                  : '${_dateLabel()} · pending',
                              subtitle: _isToday
                                  ? 'Tap the big green button when you take it'
                                  : null,
                            ),
                            SizedBox(height: 12.h),
                            ...pending.map((event) {
                              final isOverdue = _isToday &&
                                  event.scheduledDateTime.isBefore(now);
                              final isLockedEarly = _isToday &&
                                  !isOverdue &&
                                  event.scheduledDateTime
                                          .difference(now) >
                                      _earlyWindow;
                              final lockedHint = isLockedEarly
                                  ? 'Available at ${event.scheduledTime.format(context)} · ${_hoursMinutesUntil(event.scheduledDateTime)}'
                                  : null;
                              return ElderMedicineTile(
                                time: event.scheduledTime.format(context),
                                name: event.medicine.name,
                                dose:
                                    '${event.medicine.amount % 1 == 0 ? event.medicine.amount.toInt() : event.medicine.amount} ${event.medicine.type.toLowerCase()}${event.medicine.strength != null && event.medicine.strength!.isNotEmpty ? ' · ${event.medicine.strength}${event.medicine.unit ?? ''}' : ''}',
                                imagePath: event.medicine.imagePath,
                                status: MedicineStatus.pending,
                                isOverdue: isOverdue,
                                isLockedEarly: isLockedEarly,
                                lockedHint: lockedHint,
                                isLowStock: event.medicine.isLowStock,
                                daysLeft: event.medicine.daysLeft,
                                onSnooze: () =>
                                    _showSnoozeSheet(context, event),
                                onTake: () =>
                                    _logTakeWithUndo(context, event),
                                onSkip: () =>
                                    _logSkipWithUndo(context, event),
                                onTakeEarly: () =>
                                    _handleTakeEarly(context, event),
                              );
                            }),
                          ],
                          if (skipped.isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            const SectionTitle(title: 'Skipped'),
                            SizedBox(height: 12.h),
                            ...skipped.map((event) => ElderMedicineTile(
                                  time: event.scheduledTime.format(context),
                                  name: event.medicine.name,
                                  dose:
                                      '${event.medicine.amount % 1 == 0 ? event.medicine.amount.toInt() : event.medicine.amount} ${event.medicine.type.toLowerCase()}${event.medicine.strength != null && event.medicine.strength!.isNotEmpty ? ' · ${event.medicine.strength}${event.medicine.unit ?? ''}' : ''}',
                                  imagePath: event.medicine.imagePath,
                                  status: MedicineStatus.missed,
                                  isLowStock: event.medicine.isLowStock,
                                  daysLeft: event.medicine.daysLeft,
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
                                  isLowStock: event.medicine.isLowStock,
                                  daysLeft: event.medicine.daysLeft,
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
  final bool isSkipped;
  final DateTime scheduledDateTime;

  DoseEvent({
    required this.medicine,
    required this.scheduledTime,
    required this.isTaken,
    this.isSkipped = false,
    required this.scheduledDateTime,
  });
}
