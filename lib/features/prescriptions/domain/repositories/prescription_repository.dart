import '../entities/prescription.dart';

abstract class PrescriptionRepository {
  Stream<List<Prescription>> watchAll();
  Future<List<Prescription>> getAll();
  Future<void> upsert(Prescription prescription);
  Future<void> delete(String id);

  Future<void> syncFromRemote();
  Future<void> syncToRemote();
}
