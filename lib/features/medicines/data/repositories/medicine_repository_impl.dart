import 'package:meditime/core/storage/data_mappers.dart';
import 'package:meditime/core/sync/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_local_datasource.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDataSource _local;

  MedicineRepositoryImpl({
    MedicineLocalDataSource? local,
  }) : _local = local ?? MedicineLocalDataSourceImpl();

  static final MedicineRepositoryImpl instance = MedicineRepositoryImpl();

  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;

  @override
  Stream<List<Medicine>> watchAll() => _local
      .watchAll()
      .map((rows) => rows.map(DataMappers.medicineFromTable).toList());

  @override
  Future<List<Medicine>> getAll() async {
    final rows = await _local.getAll();
    return rows.map(DataMappers.medicineFromTable).toList();
  }

  @override
  Future<Medicine?> getById(String id) async {
    final row = await _local.getById(id);
    return row != null ? DataMappers.medicineFromTable(row) : null;
  }

  @override
  Future<void> upsert(Medicine medicine) async {
    await _local.upsert(DataMappers.medicineToTable(
      medicine,
      accountId: _currentUserId,
    ));
    SyncService.instance.sync();
  }

  @override
  Future<void> delete(String id) async {
    await _local.delete(id); // Local datasource should handle soft delete
    SyncService.instance.sync();
  }

  @override
  Future<void> syncFromRemote() => SyncService.instance.sync(immediate: true);

  @override
  Future<void> syncToRemote() => SyncService.instance.sync(immediate: true);
}
