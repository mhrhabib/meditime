// lib/cubits/medicine_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class Medicine {
  final String id;
  final String name;
  final String type;
  final String schedule;
  final int stockRemaining;
  final int stockTotal;
  final int daysLeft;
  final bool isLowStock;

  Medicine({
    required this.id,
    required this.name,
    required this.type,
    required this.schedule,
    required this.stockRemaining,
    required this.stockTotal,
    required this.daysLeft,
    required this.isLowStock,
  });
}

class MedicineState {
  final List<Medicine> medicines;
  const MedicineState({this.medicines = const []});
}

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(MedicineState(medicines: _mockMedicines));

  static final List<Medicine> _mockMedicines = [
    Medicine(
      id: '1',
      name: 'Metformin 500mg',
      type: 'tablet',
      schedule: 'Daily · 3× · After meal',
      stockRemaining: 21,
      stockTotal: 30,
      daysLeft: 7,
      isLowStock: false,
    ),
    Medicine(
      id: '2',
      name: 'Paracetamol 650mg',
      type: 'tablet',
      schedule: 'Daily · 2× · After meal',
      stockRemaining: 6,
      stockTotal: 30,
      daysLeft: 3,
      isLowStock: true,
    ),
    Medicine(
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

  void addMedicine(Medicine med) {
    emit(MedicineState(medicines: List.from(state.medicines)..add(med)));
  }
}
