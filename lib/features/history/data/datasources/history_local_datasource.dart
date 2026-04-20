import 'package:meditime/core/storage/app_database.dart';

abstract class HistoryLocalDataSource {
  Stream<List<DoseLogTableData>> watchAll();
  Future<List<DoseLogTableData>> getAll();
  Future<void> upsert(DoseLogTableData log);
  Future<void> delete(String id);
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  final AppDatabase _db;

  HistoryLocalDataSourceImpl({AppDatabase? db}) : _db = db ?? AppDatabase.instance;

  @override
  Stream<List<DoseLogTableData>> watchAll() => _db.watchAllDoseLogs();

  @override
  Future<List<DoseLogTableData>> getAll() => _db.getAllDoseLogs();

  @override
  Future<void> upsert(DoseLogTableData log) => _db.insertDoseLog(log);

  @override
  Future<void> delete(String id) =>
      (_db.delete(_db.doseLogTable)..where((t) => t.id.equals(id))).go();
}
