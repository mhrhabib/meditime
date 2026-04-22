import 'package:meditime/core/storage/app_database.dart';

abstract class ProfileLocalDataSource {
  Stream<List<ProfileTableData>> watchAll();
  Future<List<ProfileTableData>> getAll();
  Future<ProfileTableData?> getById(String id);
  Future<void> upsert(ProfileTableData profile);
  Future<void> delete(String id);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final AppDatabase _db;

  ProfileLocalDataSourceImpl({AppDatabase? db}) : _db = db ?? AppDatabase.instance;

  @override
  Stream<List<ProfileTableData>> watchAll() => _db.watchAllProfiles();

  @override
  Future<List<ProfileTableData>> getAll() => _db.getAllProfiles();

  @override
  Future<ProfileTableData?> getById(String id) =>
      (_db.select(_db.profileTable)
            ..where((t) => t.id.equals(id))
            ..where((t) => t.deletedAt.isNull()))
          .getSingleOrNull();

  @override
  Future<void> upsert(ProfileTableData profile) => _db.insertProfile(profile);

  @override
  Future<void> delete(String id) => _db.softDeleteProfile(id);
}
