import 'package:meditime/core/storage/app_database.dart';

abstract class EmergencyCardLocalDataSource {
  Future<EmergencyCardTableData?> get();
  Future<void> save(EmergencyCardTableData data);
}

class EmergencyCardLocalDataSourceImpl implements EmergencyCardLocalDataSource {
  final AppDatabase _db;

  EmergencyCardLocalDataSourceImpl({AppDatabase? db})
      : _db = db ?? AppDatabase.instance;

  @override
  Future<EmergencyCardTableData?> get() => _db.getEmergencyCard();

  @override
  Future<void> save(EmergencyCardTableData data) => _db.saveEmergencyCard(data);
}
