import 'package:meditime/core/storage/data_mappers.dart';
import 'package:meditime/core/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _local;

  ProfileRepositoryImpl({
    ProfileLocalDataSource? local,
  }) : _local = local ?? ProfileLocalDataSourceImpl();

  static final ProfileRepositoryImpl instance = ProfileRepositoryImpl();

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  @override
  Stream<List<Profile>> watchAll() =>
      _local.watchAll().map((rows) => rows.map(DataMappers.profileFromTable).toList());

  @override
  Future<List<Profile>> getAll() async {
    final rows = await _local.getAll();
    return rows.map(DataMappers.profileFromTable).toList();
  }

  @override
  Future<Profile?> getById(String id) async {
    final row = await _local.getById(id);
    return row != null ? DataMappers.profileFromTable(row) : null;
  }

  @override
  Future<void> upsert(Profile profile) async {
    await _local.upsert(DataMappers.profileToTable(
      profile,
      accountId: _currentUserId,
    ));
    SyncService.instance.sync();
  }

  @override
  Future<void> delete(String id) async {
    await _local.delete(id);
    SyncService.instance.sync();
  }

  @override
  Future<void> syncFromRemote() => SyncService.instance.sync(immediate: true);

  @override
  Future<void> syncToRemote() => SyncService.instance.sync(immediate: true);
}
