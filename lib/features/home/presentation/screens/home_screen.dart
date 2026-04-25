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
import 'package:meditime/core/sync/sync_service.dart';
import 'package:meditime/core/theme/app_theme.dart';
import 'package:meditime/features/home/presentation/widgets/home_shimmer_skeleton.dart';
import 'package:meditime/features/profile/presentation/screens/main_user_selection_screen.dart';
import 'package:meditime/features/notifications/presentation/screens/notification_screen.dart';

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
    // Pre-filter logs to the target day once, then key by "medId|HH:mm".
    // Keeps per-slot lookup O(1) instead of scanning the full log list twice
    // per medicine × dose time.
    final dayLogs = <String, DoseStatus>{};
    for (final log in logs) {
      final s = log.scheduledDateTime;
      if (s == null) continue;
      if (s.year != date.year || s.month != date.month || s.day != date.day) {
        continue;
      }
      final key = '${log.medicineId}|${s.hour}:${s.minute}';
      // Prefer terminal states (taken/skipped) over intermediate ones.
      final existing = dayLogs[key];
      if (existing == DoseStatus.taken || existing == DoseStatus.skipped) {
        continue;
      }
      dayLogs[key] = log.status;
    }

    final List<DoseEvent> events = [];
    for (final med in medicines) {
      // ── Filter by Active Window ──
      final daysSinceStart = date.difference(med.startDate).inDays;
      if (daysSinceStart < 0) continue; // Not started yet
      if (med.durationDays != -1 && daysSinceStart >= med.durationDays) {
        continue; // Course finished
      }

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
        final status = dayLogs['${med.id}|${time.hour}:${time.minute}'];

        events.add(DoseEvent(
          medicine: med,
          scheduledTime: time,
          isTaken: status == DoseStatus.taken,
          isSkipped: status == DoseStatus.skipped,
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
  // Grace after a scheduled time before a pending slot is treated as missed.
  static const Duration _missedGrace = Duration(minutes: 30);

  String _hoursMinutesUntil(DateTime target) {
    final diff = target.difference(DateTime.now());
    if (diff.isNegative) return 'now';
    final hours = diff.inHours;
    final minutes = diff.inMinutes - hours * 60;
    if (hours == 0) return 'in $minutes min';
    if (minutes == 0) return 'in $hours hr';
    return 'in $hours hr $minutes min';
  }

  Future<bool> _confirmTakeEarly(BuildContext context, DoseEvent event) async {
    final scheduled =
        TimeOfDay.fromDateTime(event.scheduledDateTime).format(context);
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

  Future<void> _handleTakeEarly(BuildContext context, DoseEvent event) async {
    final confirmed = await _confirmTakeEarly(context, event);
    if (!confirmed || !context.mounted) return;
    _logTakeWithUndo(context, event);
  }

  Future<void> _showSnoozeSheet(BuildContext context, DoseEvent event) async {
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
                      onPressed: () =>
                          Navigator.pop(ctx, Duration(minutes: minutes)),
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
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[_selectedDate.month - 1]} ${_selectedDate.day}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (prev, curr) =>
            curr.needsMainUserSelection && !prev.needsMainUserSelection,
        listener: (context, state) {
          if (state.needsMainUserSelection) {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const MainUserSelectionScreen(),
              ),
            );
          }
        },
        child: Stack(
          children: [
            CustomScrollView(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 12.w),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        final firstName =
                            state.activeProfileName.split(' ').first;
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
                            final untracked = allEvents
                                .where((e) => !e.isTaken && !e.isSkipped)
                                .toList();

                            // A slot is "missed" once now > scheduledTime + grace.
                            // For non-today past dates, the whole day is past —
                            // everything untracked is missed.
                            bool isMissedSlot(DoseEvent e) {
                              if (!_isToday) {
                                return _selectedDate.isBefore(DateTime(
                                    now.year, now.month, now.day));
                              }
                              return e.scheduledDateTime
                                  .add(_missedGrace)
                                  .isBefore(now);
                            }

                            final missed =
                                untracked.where(isMissedSlot).toList();
                            final overdue = _isToday
                                ? untracked
                                    .where((e) =>
                                        e.scheduledDateTime.isBefore(now) &&
                                        !isMissedSlot(e))
                                    .toList()
                                : <DoseEvent>[];
                            final upcoming = _isToday
                                ? untracked
                                    .where((e) =>
                                        !e.scheduledDateTime.isBefore(now))
                                    .toList()
                                : <DoseEvent>[];
                            final pending = [...overdue, ...upcoming];
                            final taken =
                                allEvents.where((e) => e.isTaken).toList();
                            final skipped =
                                allEvents.where((e) => e.isSkipped).toList();
                            final nextDose = _isToday && upcoming.isNotEmpty
                                ? upcoming.first
                                : null;

                            if (medState.medicines.isEmpty) {
                              return ValueListenableBuilder<bool>(
                                valueListenable: SyncService.instance.syncing,
                                builder: (context, syncing, child) {
                                  if (syncing) {
                                    return const HomeShimmerSkeleton();
                                  }
                                  return HomeEmptyState(
                                    onAdd: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const AddMedicineScreen()),
                                    ),
                                  );
                                },
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TodaySummary(
                                  pendingCount: pending.length,
                                  takenCount: taken.length,
                                  missedCount: missed.length,
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
                                if (_isToday &&
                                    now.hour >= 22 &&
                                    missed.isNotEmpty)
                                  _EndOfDayMissedBanner(
                                    missedCount: missed.length,
                                  ),
                                if (nextDose != null &&
                                    nextDose.scheduledDateTime
                                            .difference(now) <=
                                        _earlyWindow)
                                  NextDoseBanner(
                                    medicine: nextDose.medicine,
                                    scheduledDateTime:
                                        nextDose.scheduledDateTime,
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
                                if (missed.isNotEmpty) ...[
                                  SizedBox(height: 12.h),
                                  SectionTitle(
                                    title: _isToday
                                        ? 'Missed today'
                                        : '${_dateLabel()} · missed',
                                    subtitle: 'Tap "I actually took it" if you remember taking it',
                                  ),
                                  SizedBox(height: 12.h),
                                  ...missed.map((event) => ElderMedicineTile(
                                        time:
                                            event.scheduledTime.format(context),
                                        name: event.medicine.name,
                                        dose:
                                            '${event.medicine.amount % 1 == 0 ? event.medicine.amount.toInt() : event.medicine.amount} ${event.medicine.type.toLowerCase()}${event.medicine.strength != null && event.medicine.strength!.isNotEmpty ? ' · ${event.medicine.strength}${event.medicine.unit ?? ''}' : ''}',
                                        imagePath: event.medicine.imagePath,
                                        status: MedicineStatus.missed,
                                        isLowStock: event.medicine.isLowStock,
                                        daysLeft: event.medicine.daysLeft,
                                        onLogLate: () =>
                                            _logTakeWithUndo(context, event),
                                      )),
                                ],
                                if (skipped.isNotEmpty) ...[
                                  SizedBox(height: 12.h),
                                  const SectionTitle(title: 'Skipped'),
                                  SizedBox(height: 12.h),
                                  ...skipped.map((event) => ElderMedicineTile(
                                        time:
                                            event.scheduledTime.format(context),
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
                                        time:
                                            event.scheduledTime.format(context),
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
          ],
        ),
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

/// Shown on home screen after 10pm if any of today's doses are still untracked.
/// Closes the loop on the daily 10pm push — the push reminds the user to open
/// the app; this banner tells them exactly what's outstanding once they do.
class _EndOfDayMissedBanner extends StatelessWidget {
  final int missedCount;
  const _EndOfDayMissedBanner({required this.missedCount});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final missedColor = StatusColors.getMissed(context);
    final bg = StatusColors.getMissedContainer(context);
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
            color: missedColor.withValues(alpha: 0.35), width: 1.5.w),
      ),
      child: Row(
        children: [
          Icon(Icons.nightlight_round, size: 28.r, color: missedColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  missedCount == 1
                      ? 'You have 1 missed dose today'
                      : 'You have $missedCount missed doses today',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Review below — tap "I actually took it" if you took any.',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface.withValues(alpha: 0.7),
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
