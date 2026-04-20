import 'package:meditime/core/storage/data_mappers.dart';

import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource _local;
  final ProfileRemoteDataSource _remote;

  ProfileRepositoryImpl({
    ProfileLocalDataSource? local,
    ProfileRemoteDataSource? remote,
  })  : _local = local ?? ProfileLocalDataSourceImpl(),
        _remote = remote ?? ProfileRemoteDataSourceImpl();

  static final ProfileRepositoryImpl instance = ProfileRepositoryImpl();

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
    await _local.upsert(DataMappers.profileToTable(profile));
    // TODO(sync): enqueue _remote.push(profile) when online
  }

  @override
  Future<void> delete(String id) async {
    await _local.delete(id);
    // TODO(sync): enqueue _remote.delete(id) when online
  }

  @override
  Future<void> syncFromRemote() async {
    try {
      final remote = await _remote.fetchAll();
      for (final profile in remote) {
        await _local.upsert(DataMappers.profileToTable(profile));
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }

  @override
  Future<void> syncToRemote() async {
    try {
      final local = await getAll();
      for (final profile in local) {
        await _remote.push(profile);
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }
}
