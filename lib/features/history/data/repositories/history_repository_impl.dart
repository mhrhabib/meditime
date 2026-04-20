import 'package:meditime/core/storage/data_mappers.dart';

import '../../domain/entities/dose_log.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';
import '../datasources/history_remote_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource _local;
  final HistoryRemoteDataSource _remote;

  HistoryRepositoryImpl({
    HistoryLocalDataSource? local,
    HistoryRemoteDataSource? remote,
  })  : _local = local ?? HistoryLocalDataSourceImpl(),
        _remote = remote ?? HistoryRemoteDataSourceImpl();

  static final HistoryRepositoryImpl instance = HistoryRepositoryImpl();

  @override
  Stream<List<DoseLog>> watchAll() =>
      _local.watchAll().map((rows) => rows.map(DataMappers.doseLogFromTable).toList());

  @override
  Future<List<DoseLog>> getAll() async {
    final rows = await _local.getAll();
    return rows.map(DataMappers.doseLogFromTable).toList();
  }

  @override
  Future<void> add(DoseLog log) async {
    await _local.upsert(DataMappers.doseLogToTable(log));
  }

  @override
  Future<void> delete(String id) async {
    await _local.delete(id);
  }

  @override
  Future<void> syncFromRemote() async {
    try {
      final remote = await _remote.fetchAll();
      for (final log in remote) {
        await _local.upsert(DataMappers.doseLogToTable(log));
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }

  @override
  Future<void> syncToRemote() async {
    try {
      final local = await getAll();
      for (final log in local) {
        await _remote.push(log);
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }
}
