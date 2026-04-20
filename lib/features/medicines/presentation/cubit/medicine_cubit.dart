import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
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

class MedicineState {
  final List<Medicine> medicines;
  const MedicineState({this.medicines = const []});
}

class MedicineCubit extends Cubit<MedicineState> {
  final MedicineRepository _repo;
  final HistoryRepository _historyRepo;
  StreamSubscription? _sub;
  String _currentProfileId = 'me';

  MedicineCubit({
    MedicineRepository? repo,
    HistoryRepository? historyRepo,
  })  : _repo = repo ?? MedicineRepositoryImpl.instance,
        _historyRepo = historyRepo ?? HistoryRepositoryImpl.instance,
        super(const MedicineState()) {
    _sub = _repo.watchAll().listen(_onMedicines);
  }

  void setProfile(String profileId) async {
    _currentProfileId = profileId;
    final all = await _repo.getAll();
    _onMedicines(all);
  }

  void _onMedicines(List<Medicine> all) {
    final filtered = all
        .where((m) => (m.profileId ?? 'me') == _currentProfileId)
        .toList();
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

  Future<void> takeDose(String medicineId, {DateTime? scheduledTime}) async {
    final med = await _repo.getById(medicineId);
    if (med == null) return;

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

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
