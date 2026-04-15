import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditime/core/storage/hive_boxes.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';
import 'package:meditime/features/medicines/data/models/medicine_model.dart';
import 'package:meditime/features/medicines/data/medicine_scheduler.dart';
import 'dart:async';

class MedicineState {
  final List<Medicine> medicines;
  const MedicineState({this.medicines = const []});
}

class MedicineCubit extends Cubit<MedicineState> {
  final Box<MedicineModel> _medicineBox = Hive.box<MedicineModel>(HiveBoxes.medicines);
  StreamSubscription? _boxSubscription;

  MedicineCubit() : super(const MedicineState()) {
    _loadMedicines();
    _boxSubscription = _medicineBox.watch().listen((_) {
      _loadMedicines();
    });
  }

  void _loadMedicines() async {
    final medicines = _medicineBox.values.toList();
    if (medicines.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final seeded = prefs.getBool('meds_seeded') ?? false;
      if (!seeded) {
        await prefs.setBool('meds_seeded', true);
        _loadMockData();
        return;
      }
    }
    emit(MedicineState(medicines: medicines));
  }

  void _loadMockData() {
    final mocks = [
        const MedicineModel(
          id: '1',
          name: 'Metformin 500mg',
          type: 'tablet',
          schedule: 'Daily · 3× · After meal',
          stockRemaining: 21,
          stockTotal: 30,
          daysLeft: 7,
          isLowStock: false,
        ),
        const MedicineModel(
          id: '2',
          name: 'Paracetamol 650mg',
          type: 'tablet',
          schedule: 'Daily · 2× · After meal',
          stockRemaining: 6,
          stockTotal: 30,
          daysLeft: 3,
          isLowStock: true,
        ),
        const MedicineModel(
          id: '3',
          name: 'Vitamin D3',
          type: 'tablet',
          schedule: 'Daily · 1× · After lunch',
          stockRemaining: 30,
          stockTotal: 30,
          daysLeft: 30,
          isLowStock: false,
        ),
      ];
      for (var mock in mocks) {
        _medicineBox.put(mock.id, mock);
      }
  }

  Future<void> addMedicine(Medicine med) async {
    final model = MedicineModel.fromEntity(med);
    await _medicineBox.put(model.id, model);
    await MedicineScheduler.scheduleForMedicine(med);
  }

  Future<void> updateMedicine(Medicine med) async {
    final model = MedicineModel.fromEntity(med);
    await _medicineBox.put(model.id, model);
    await MedicineScheduler.rescheduleForMedicine(med);
  }

  Future<void> deleteMedicine(String id) async {
    final med = _medicineBox.get(id);
    if (med != null) {
      await MedicineScheduler.cancelForMedicine(med);
    }
    await _medicineBox.delete(id);
  }

  @override
  Future<void> close() {
    _boxSubscription?.cancel();
    return super.close();
  }
}
