import 'package:meditime/core/storage/data_mappers.dart';
import 'package:meditime/core/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/prescription.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../datasources/prescription_local_datasource.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionLocalDataSource _local;

  PrescriptionRepositoryImpl({
    PrescriptionLocalDataSource? local,
  }) : _local = local ?? PrescriptionLocalDataSourceImpl();

  static final PrescriptionRepositoryImpl instance =
      PrescriptionRepositoryImpl();

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  @override
  Stream<List<Prescription>> watchAll() => _local
      .watchAll()
      .map((rows) => rows.map(DataMappers.prescriptionFromTable).toList());

  @override
  Future<List<Prescription>> getAll() async {
    final rows = await _local.getAll();
    return rows.map(DataMappers.prescriptionFromTable).toList();
  }

  @override
  Future<void> upsert(Prescription prescription) async {
    await _local.upsert(DataMappers.prescriptionToTable(
      prescription,
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
