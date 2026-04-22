import 'package:meditime/core/storage/app_database.dart';

abstract class PrescriptionLocalDataSource {
  Stream<List<PrescriptionTableData>> watchAll();
  Future<List<PrescriptionTableData>> getAll();
  Future<void> upsert(PrescriptionTableData rx);
  Future<void> delete(String id);
}

class PrescriptionLocalDataSourceImpl implements PrescriptionLocalDataSource {
  final AppDatabase _db;

  PrescriptionLocalDataSourceImpl({AppDatabase? db})
      : _db = db ?? AppDatabase.instance;

  @override
  Stream<List<PrescriptionTableData>> watchAll() => _db.watchAllPrescriptions();

  @override
  Future<List<PrescriptionTableData>> getAll() => _db.getAllPrescriptions();

  @override
  Future<void> upsert(PrescriptionTableData rx) => _db.insertPrescription(rx);

  @override
  Future<void> delete(String id) => _db.softDeletePrescription(id);
}
