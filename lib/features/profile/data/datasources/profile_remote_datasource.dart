import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meditime/core/storage/app_database.dart';

abstract class ProfileRemoteDataSource {
  Future<List<ProfileTableData>> fetchDelta(int since);
  Future<void> push(ProfileTableData profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final _client = Supabase.instance.client;
  static const _table = 'profiles';

  @override
  Future<List<ProfileTableData>> fetchDelta(int since) async {
    final response = await _client
        .from(_table)
        .select()
        .gt('updated_at', since)
        .order('updated_at', ascending: true);

    return (response as List).map((json) => _fromJson(json)).toList();
  }

  @override
  Future<void> push(ProfileTableData profile) async {
    await _client.from(_table).upsert(_toJson(profile));
  }

  ProfileTableData _fromJson(Map<String, dynamic> json) {
    return ProfileTableData(
      id: json['id'],
      name: json['name'],
      initials: json['initials'],
      age: json['age'],
      gender: json['gender'],
      // sync
      accountId: json['account_id'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      dirty: false,
      lastWriterDeviceId: json['last_writer_device_id'],
    );
  }

  Map<String, dynamic> _toJson(ProfileTableData data) {
    return {
      'id': data.id,
      'name': data.name,
      'initials': data.initials,
      'age': data.age,
      'gender': data.gender,
      // sync
      'account_id': data.accountId,
      'updated_at': data.updatedAt,
      'deleted_at': data.deletedAt,
      'last_writer_device_id': data.lastWriterDeviceId,
    };
  }
}
