import '../../domain/entities/prescription.dart';

abstract class PrescriptionRemoteDataSource {
  Future<List<Prescription>> fetchAll();
  Future<void> push(Prescription prescription);
  Future<void> delete(String id);
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  @override
  Future<List<Prescription>> fetchAll() {
    throw UnimplementedError('Prescriptions API integration pending');
  }

  @override
  Future<void> push(Prescription prescription) {
    throw UnimplementedError('Prescriptions API integration pending');
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError('Prescriptions API integration pending');
  }
}
