import 'package:meditime/core/storage/data_mappers.dart';

import '../../domain/entities/medicine.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_local_datasource.dart';
import '../datasources/medicine_remote_datasource.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineLocalDataSource _local;
  final MedicineRemoteDataSource _remote;

  MedicineRepositoryImpl({
    MedicineLocalDataSource? local,
    MedicineRemoteDataSource? remote,
  })  : _local = local ?? MedicineLocalDataSourceImpl(),
        _remote = remote ?? MedicineRemoteDataSourceImpl();

  static final MedicineRepositoryImpl instance = MedicineRepositoryImpl();

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
    await _local.upsert(DataMappers.medicineToTable(medicine));
  }

  @override
  Future<void> delete(String id) async {
    await _local.delete(id);
  }

  @override
  Future<void> syncFromRemote() async {
    try {
      final remote = await _remote.fetchAll();
      for (final med in remote) {
        await _local.upsert(DataMappers.medicineToTable(med));
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }

  @override
  Future<void> syncToRemote() async {
    try {
      final local = await getAll();
      for (final med in local) {
        await _remote.push(med);
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }
}
