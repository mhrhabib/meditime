import '../../domain/entities/medicine.dart';

abstract class MedicineRemoteDataSource {
  Future<List<Medicine>> fetchAll();
  Future<void> push(Medicine medicine);
  Future<void> delete(String id);
}

class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  @override
  Future<List<Medicine>> fetchAll() {
    throw UnimplementedError('Medicines API integration pending');
  }

  @override
  Future<void> push(Medicine medicine) {
    throw UnimplementedError('Medicines API integration pending');
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError('Medicines API integration pending');
  }
}
