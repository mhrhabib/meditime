import 'package:meditime/core/storage/data_mappers.dart';
import 'package:meditime/core/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/dose_log.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_datasource.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource _local;

  HistoryRepositoryImpl({
    HistoryLocalDataSource? local,
  }) : _local = local ?? HistoryLocalDataSourceImpl();

  static final HistoryRepositoryImpl instance = HistoryRepositoryImpl();

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

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
    await _local.upsert(DataMappers.doseLogToTable(
      log,
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
