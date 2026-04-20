import '../entities/medicine.dart';

abstract class MedicineRepository {
  Stream<List<Medicine>> watchAll();
  Future<List<Medicine>> getAll();
  Future<Medicine?> getById(String id);
  Future<void> upsert(Medicine medicine);
  Future<void> delete(String id);

  Future<void> syncFromRemote();
  Future<void> syncToRemote();
}
