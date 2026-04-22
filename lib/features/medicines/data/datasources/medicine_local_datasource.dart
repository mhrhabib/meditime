import 'package:meditime/core/storage/app_database.dart';

abstract class MedicineLocalDataSource {
  Stream<List<MedicineTableData>> watchAll();
  Future<List<MedicineTableData>> getAll();
  Future<MedicineTableData?> getById(String id);
  Future<void> upsert(MedicineTableData medicine);
  Future<void> delete(String id);
}

class MedicineLocalDataSourceImpl implements MedicineLocalDataSource {
  final AppDatabase _db;

  MedicineLocalDataSourceImpl({AppDatabase? db})
      : _db = db ?? AppDatabase.instance;

  @override
  Stream<List<MedicineTableData>> watchAll() => _db.watchAllMedicines();

  @override
  Future<List<MedicineTableData>> getAll() => _db.getAllMedicines();

  @override
  Future<MedicineTableData?> getById(String id) => _db.getMedicineById(id);

  @override
  Future<void> upsert(MedicineTableData medicine) => _db.insertMedicine(medicine);

  @override
  Future<void> delete(String id) => _db.softDeleteMedicine(id);
}
