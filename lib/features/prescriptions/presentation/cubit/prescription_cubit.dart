import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meditime/core/storage/hive_boxes.dart';
import 'package:meditime/features/prescriptions/domain/entities/prescription.dart';
import 'package:meditime/features/prescriptions/data/models/prescription_model.dart';
import 'dart:async';

class PrescriptionState {
  final List<Prescription> prescriptions;
  const PrescriptionState({this.prescriptions = const []});
}

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final Box<PrescriptionModel> _prescriptionBox = Hive.box<PrescriptionModel>(HiveBoxes.prescriptions);
  StreamSubscription? _boxSubscription;

  PrescriptionCubit() : super(const PrescriptionState()) {
    _loadPrescriptions();
    _boxSubscription = _prescriptionBox.watch().listen((_) {
      _loadPrescriptions();
    });
  }

  void _loadPrescriptions() {
    final prescriptions = _prescriptionBox.values.toList();
    if (prescriptions.isEmpty) {
      _loadMockPrescriptions();
    } else {
      emit(PrescriptionState(prescriptions: prescriptions));
    }
  }

  void _loadMockPrescriptions() {
    final mocks = [
      PrescriptionModel(
        id: 'p1',
        doctorName: 'Dr. Rahman',
        date: DateTime(2026, 3, 10),
        reason: 'Diabetes checkup',
        medicines: const ['Metformin', 'Vitamin D3', 'Amlodipine'],
      ),
      PrescriptionModel(
        id: 'p2',
        doctorName: 'Dr. Hossain',
        date: DateTime(2026, 1, 2),
        reason: 'BP followup',
        medicines: const [],
      ),
      PrescriptionModel(
        id: 'p3',
        doctorName: 'Dr. Alam',
        date: DateTime(2025, 11, 5),
        reason: 'General checkup',
        medicines: const ['Paracetamol'],
      ),
    ];
    for (var mock in mocks) {
      _prescriptionBox.put(mock.id, mock);
    }
  }

  void addPrescription(Prescription rx) {
    final model = PrescriptionModel.fromEntity(rx);
    _prescriptionBox.put(model.id, model);
  }

  void deletePrescription(String id) {
    _prescriptionBox.delete(id);
  }

  @override
  Future<void> close() {
    _boxSubscription?.cancel();
    return super.close();
  }
}
