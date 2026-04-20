import '../entities/dose_log.dart';

abstract class HistoryRepository {
  Stream<List<DoseLog>> watchAll();
  Future<List<DoseLog>> getAll();
  Future<void> add(DoseLog log);
  Future<void> delete(String id);

  Future<void> syncFromRemote();
  Future<void> syncToRemote();
}
