import '../entities/profile.dart';

abstract class ProfileRepository {
  Stream<List<Profile>> watchAll();
  Future<List<Profile>> getAll();
  Future<Profile?> getById(String id);
  Future<void> upsert(Profile profile);
  Future<void> delete(String id);

  Future<void> syncFromRemote();
  Future<void> syncToRemote();
}
