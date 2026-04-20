import '../entities/emergencycard.dart';

abstract class EmergencyCardRepository {
  Future<EmergencyCard?> get();
  Future<void> save(EmergencyCard card);

  Future<void> syncFromRemote();
  Future<void> syncToRemote();
}
