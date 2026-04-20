import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/features/prescriptions/data/repositories/prescription_repository_impl.dart';
import 'package:meditime/features/prescriptions/domain/entities/prescription.dart';
import 'package:meditime/features/prescriptions/domain/repositories/prescription_repository.dart';

class PrescriptionState {
  final List<Prescription> prescriptions;
  const PrescriptionState({this.prescriptions = const []});
}

class PrescriptionCubit extends Cubit<PrescriptionState> {
  final PrescriptionRepository _repo;
  StreamSubscription? _sub;

  PrescriptionCubit({PrescriptionRepository? repo})
      : _repo = repo ?? PrescriptionRepositoryImpl.instance,
        super(const PrescriptionState()) {
    _sub = _repo.watchAll().listen((prescriptions) {
      emit(PrescriptionState(prescriptions: prescriptions));
    });
  }

  Future<void> addPrescription(Prescription rx) async {
    await _repo.upsert(rx);
  }

  Future<void> updatePrescription(Prescription rx) async {
    await _repo.upsert(rx);
  }

  Future<void> deletePrescription(String id) async {
    await _repo.delete(id);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
