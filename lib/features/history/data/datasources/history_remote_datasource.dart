import '../../domain/entities/dose_log.dart';

abstract class HistoryRemoteDataSource {
  Future<List<DoseLog>> fetchAll();
  Future<void> push(DoseLog log);
  Future<void> delete(String id);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  @override
  Future<List<DoseLog>> fetchAll() {
    throw UnimplementedError('History API integration pending');
  }

  @override
  Future<void> push(DoseLog log) {
    throw UnimplementedError('History API integration pending');
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError('History API integration pending');
  }
}
