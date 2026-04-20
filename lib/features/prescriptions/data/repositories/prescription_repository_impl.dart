import 'package:meditime/core/storage/data_mappers.dart';

import '../../domain/entities/prescription.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../datasources/prescription_local_datasource.dart';
import '../datasources/prescription_remote_datasource.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionLocalDataSource _local;
  final PrescriptionRemoteDataSource _remote;

  PrescriptionRepositoryImpl({
    PrescriptionLocalDataSource? local,
    PrescriptionRemoteDataSource? remote,
  })  : _local = local ?? PrescriptionLocalDataSourceImpl(),
        _remote = remote ?? PrescriptionRemoteDataSourceImpl();

  static final PrescriptionRepositoryImpl instance =
      PrescriptionRepositoryImpl();

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
    await _local.upsert(DataMappers.prescriptionToTable(prescription));
  }

  @override
  Future<void> delete(String id) async {
    await _local.delete(id);
  }

  @override
  Future<void> syncFromRemote() async {
    try {
      final remote = await _remote.fetchAll();
      for (final rx in remote) {
        await _local.upsert(DataMappers.prescriptionToTable(rx));
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }

  @override
  Future<void> syncToRemote() async {
    try {
      final local = await getAll();
      for (final rx in local) {
        await _remote.push(rx);
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }
}
