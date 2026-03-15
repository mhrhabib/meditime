// lib/cubits/prescription_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class Prescription {
  final String id;
  final String doctorName;
  final String date;
  final String reason;
  final List<String> medicines;
  final bool isScanned;

  Prescription({
    required this.id,
    required this.doctorName,
    required this.date,
    required this.reason,
    required this.medicines,
    required this.isScanned,
  });
}

class PrescriptionState {
  final List<Prescription> prescriptions;
  const PrescriptionState({this.prescriptions = const []});
}

class PrescriptionCubit extends Cubit<PrescriptionState> {
  PrescriptionCubit() : super(PrescriptionState(prescriptions: _mockPrescriptions));

  static final List<Prescription> _mockPrescriptions = [
    Prescription(
      id: 'p1',
      doctorName: 'Dr. Rahman',
      date: '10 Mar 2026',
      reason: 'Diabetes checkup',
      medicines: ['Metformin', 'Vitamin D3', 'Amlodipine'],
      isScanned: true,
    ),
    Prescription(
      id: 'p2',
      doctorName: 'Dr. Hossain',
      date: '2 Jan 2026',
      reason: 'BP followup',
      medicines: [],
      isScanned: false,
    ),
    Prescription(
      id: 'p3',
      doctorName: 'Dr. Alam',
      date: '5 Nov 2025',
      reason: 'General checkup',
      medicines: ['Paracetamol'],
      isScanned: true,
    ),
  ];

  void addPrescription(Prescription rx) {
    emit(PrescriptionState(prescriptions: List.from(state.prescriptions)..add(rx)));
  }
}
