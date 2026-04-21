import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/alarm/medicine_alarm_service.dart';
import 'package:meditime/core/notifications/notification_channels.dart';
import 'package:meditime/core/notifications/notification_service.dart';
import 'package:meditime/features/history/data/repositories/history_repository_impl.dart';
import 'package:meditime/features/history/domain/entities/dose_log.dart';
import 'package:meditime/features/history/domain/repositories/history_repository.dart';
import 'package:meditime/features/medicines/data/medicine_scheduler.dart';
import 'package:meditime/features/medicines/data/repositories/medicine_repository_impl.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';
import 'package:meditime/features/medicines/domain/refill_predictor.dart';
import 'package:meditime/features/medicines/domain/repositories/medicine_repository.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';

class MedicineState {
  final List<Medicine> medicines;
  const MedicineState({this.medicines = const []});
}

class MedicineCubit extends Cubit<MedicineState> {
  final MedicineRepository _repo;
  final HistoryRepository _historyRepo;
  final ProfileCubit _profileCubit;
  StreamSubscription? _sub;
  StreamSubscription? _profileSub;
  String _currentProfileId = 'me';

  MedicineCubit({
    MedicineRepository? repo,
    HistoryRepository? historyRepo,
    required ProfileCubit profileCubit,
  })  : _repo = repo ?? MedicineRepositoryImpl.instance,
        _historyRepo = historyRepo ?? HistoryRepositoryImpl.instance,
        _profileCubit = profileCubit,
        super(const MedicineState()) {
    _currentProfileId = _profileCubit.state.activeProfile?.id ?? 'me';
    _sub = _repo.watchAll().listen(_onMedicines);
    _profileSub = _profileCubit.stream.listen((ps) {
      setProfile(ps.activeProfile?.id ?? 'me');
    });
  }

  void setProfile(String profileId) async {
    _currentProfileId = profileId;
    final all = await _repo.getAll();
    _onMedicines(all);
  }

  void _onMedicines(List<Medicine> all) {
    final filtered =
        all.where((m) => (m.profileId ?? 'me') == _currentProfileId).toList();
    emit(MedicineState(medicines: filtered));
  }

  Future<void> addMedicine(Medicine med) async {
    await _repo.upsert(med);
    await MedicineScheduler.scheduleForMedicine(med);
  }

  Future<void> updateMedicine(Medicine med) async {
    await _repo.upsert(med);
    await MedicineScheduler.rescheduleForMedicine(med);
  }

  Future<void> deleteMedicine(String id) async {
    final med = await _repo.getById(id);
    if (med != null) {
      await MedicineScheduler.cancelForMedicine(med);
    }
    await _repo.delete(id);
  }

  Future<void> takeDose(String medicineId,
      {DateTime? scheduledTime, int doseIdx = 0}) async {
    final med = await _repo.getById(medicineId);
    if (med == null) return;

    if (scheduledTime != null) {
      await MedicineScheduler.cancelDose(
        medicineId: medicineId,
        doseIdx: doseIdx,
        scheduledTime: scheduledTime,
      );
    }

    final newStock = (med.stockRemaining - 1).clamp(0, med.stockTotal);
    final dosesPerDay = RefillPredictor.parseDosesPerDay(med.schedule);
    final prediction = RefillPredictor.predict(
      currentStock: newStock,
      dosesPerDay: dosesPerDay,
    );

    final updated = med.copyWith(
      stockRemaining: newStock,
      daysLeft: prediction.daysRemaining,
      isLowStock: prediction.isWarning,
    );
    await _repo.upsert(updated);

    await _historyRepo.add(DoseLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: medicineId,
      medicineName: med.name,
      dateTime: DateTime.now(),
      status: DoseStatus.taken,
      scheduledDateTime: scheduledTime,
    ));

    if (prediction.daysRemaining == 3 ||
        prediction.daysRemaining == 1 ||
        newStock == 0) {
      await NotificationService.instance.showNow(
        id: medicineId.hashCode + 999,
        title: '⚠️ Refill Reminder: ${med.name}',
        body: prediction.message,
        channelId: NotificationChannels.refillAlerts,
      );
    }
  }

  Future<void> undoTakeDose(String medicineId,
      {DateTime? scheduledTime}) async {
    final med = await _repo.getById(medicineId);
    if (med == null) return;

    final logs = await _historyRepo.getAll();
    DoseLog? match;
    for (final log in logs) {
      if (log.medicineId != medicineId) continue;
      if (log.status != DoseStatus.taken) continue;
      if (scheduledTime != null) {
        if (log.scheduledDateTime == null) continue;
        if (!log.scheduledDateTime!.isAtSameMomentAs(scheduledTime)) continue;
      }
      if (match == null || log.dateTime.isAfter(match.dateTime)) {
        match = log;
      }
    }
    if (match == null) return;

    await _historyRepo.delete(match.id);

    final newStock = (med.stockRemaining + 1).clamp(0, med.stockTotal);
    final dosesPerDay = RefillPredictor.parseDosesPerDay(med.schedule);
    final prediction = RefillPredictor.predict(
      currentStock: newStock,
      dosesPerDay: dosesPerDay,
    );
    await _repo.upsert(med.copyWith(
      stockRemaining: newStock,
      daysLeft: prediction.daysRemaining,
      isLowStock: prediction.isWarning,
    ));
  }

  Future<void> skipDose(String medicineId,
      {DateTime? scheduledTime, int doseIdx = 0}) async {
    final med = await _repo.getById(medicineId);
    if (med == null) return;

    if (scheduledTime != null) {
      await MedicineScheduler.cancelDose(
        medicineId: medicineId,
        doseIdx: doseIdx,
        scheduledTime: scheduledTime,
      );
    }

    await _historyRepo.add(DoseLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: medicineId,
      medicineName: med.name,
      dateTime: DateTime.now(),
      status: DoseStatus.skipped,
      scheduledDateTime: scheduledTime,
    ));
  }

  Future<void> snoozeDose(
    String medicineId, {
    required DateTime scheduledTime,
    required Duration delay,
    int doseIdx = 0,
  }) async {
    final med = await _repo.getById(medicineId);
    if (med == null) return;

    await MedicineScheduler.cancelDose(
      medicineId: medicineId,
      doseIdx: doseIdx,
      scheduledTime: scheduledTime,
    );

    await _historyRepo.add(DoseLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      medicineId: medicineId,
      medicineName: med.name,
      dateTime: DateTime.now(),
      status: DoseStatus.snoozed,
      scheduledDateTime: scheduledTime,
    ));

    final fireAt = DateTime.now().add(delay);
    // flutter_local_notifications validates id as a signed int32. Unix
    // seconds are already ~1.76B in 2026, so adding any positive hashCode
    // overflows the 2^31-1 ceiling. XOR + mask to 31 bits keeps the id
    // stable-per-dose and within range.
    final notifId = (medicineId.hashCode ^
            (fireAt.millisecondsSinceEpoch ~/ 1000)) &
        0x7FFFFFFF;
    await NotificationService.instance.scheduleNotification(
      id: notifId,
      title: '⏰ Snoozed reminder: ${med.name}',
      body: 'Time to take your ${med.name}',
      scheduledTime: fireAt,
      payload: '$medicineId|0|${scheduledTime.toIso8601String()}',
      channelId: NotificationChannels.medsDefault,
    );
    // Fire the loud alarm on the snooze too — silent snoozes defeat the
    // whole point of the alarm for elderly users.
    await MedicineAlarmService.instance.scheduleForDose(
      id: notifId,
      fireAt: fireAt,
      medicineName: med.name,
      body: 'Snoozed reminder — time to take your ${med.name}',
    );
  }

  Future<void> undoSkipDose(String medicineId,
      {DateTime? scheduledTime}) async {
    final logs = await _historyRepo.getAll();
    DoseLog? match;
    for (final log in logs) {
      if (log.medicineId != medicineId) continue;
      if (log.status != DoseStatus.skipped) continue;
      if (scheduledTime != null) {
        if (log.scheduledDateTime == null) continue;
        if (!log.scheduledDateTime!.isAtSameMomentAs(scheduledTime)) continue;
      }
      if (match == null || log.dateTime.isAfter(match.dateTime)) {
        match = log;
      }
    }
    if (match == null) return;
    await _historyRepo.delete(match.id);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    _profileSub?.cancel();
    return super.close();
  }
}
