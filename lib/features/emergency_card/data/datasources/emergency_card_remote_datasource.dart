import '../../domain/entities/emergencycard.dart';

abstract class EmergencyCardRemoteDataSource {
  Future<EmergencyCard?> fetch();
  Future<void> push(EmergencyCard card);
}

class EmergencyCardRemoteDataSourceImpl implements EmergencyCardRemoteDataSource {
  @override
  Future<EmergencyCard?> fetch() {
    throw UnimplementedError('Emergency card API integration pending');
  }

  @override
  Future<void> push(EmergencyCard card) {
    throw UnimplementedError('Emergency card API integration pending');
  }
}
