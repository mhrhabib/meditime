import '../../domain/entities/profile.dart';

abstract class ProfileRemoteDataSource {
  Future<List<Profile>> fetchAll();
  Future<void> push(Profile profile);
  Future<void> delete(String id);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<List<Profile>> fetchAll() {
    throw UnimplementedError('Profile API integration pending');
  }

  @override
  Future<void> push(Profile profile) {
    throw UnimplementedError('Profile API integration pending');
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError('Profile API integration pending');
  }
}
