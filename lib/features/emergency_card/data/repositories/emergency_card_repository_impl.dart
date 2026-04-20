import 'package:meditime/core/storage/data_mappers.dart';

import '../../domain/entities/emergencycard.dart';
import '../../domain/repositories/emergency_card_repository.dart';
import '../datasources/emergency_card_local_datasource.dart';
import '../datasources/emergency_card_remote_datasource.dart';

class EmergencyCardRepositoryImpl implements EmergencyCardRepository {
  final EmergencyCardLocalDataSource _local;
  final EmergencyCardRemoteDataSource _remote;

  EmergencyCardRepositoryImpl({
    EmergencyCardLocalDataSource? local,
    EmergencyCardRemoteDataSource? remote,
  })  : _local = local ?? EmergencyCardLocalDataSourceImpl(),
        _remote = remote ?? EmergencyCardRemoteDataSourceImpl();

  static final EmergencyCardRepositoryImpl instance =
      EmergencyCardRepositoryImpl();

  @override
  Future<EmergencyCard?> get() async {
    final row = await _local.get();
    return row != null ? DataMappers.emergencyCardFromTable(row) : null;
  }

  @override
  Future<void> save(EmergencyCard card) async {
    await _local.save(DataMappers.emergencyCardToTable(card));
  }

  @override
  Future<void> syncFromRemote() async {
    try {
      final remote = await _remote.fetch();
      if (remote != null) {
        await _local.save(DataMappers.emergencyCardToTable(remote));
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }

  @override
  Future<void> syncToRemote() async {
    try {
      final local = await get();
      if (local != null) {
        await _remote.push(local);
      }
    } on UnimplementedError {
      // API not yet implemented
    }
  }
}
