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
    var query = _client.from(_table).select();
    if (since > 0) {
      final sinceIso = DateTime.fromMillisecondsSinceEpoch(since).toUtc().toIso8601String();
      query = query.gt('updated_at', sinceIso);
    }

    try {
      final response = await query.order('updated_at', ascending: true);
      return (response as List).map((json) => _fromJson(json)).toList();
    } catch (e) {
      // Some Supabase/Postgrest setups may have divergent schemas (e.g. older
      // profile table without `age`). If the server complains about a missing
      // column, retry with a reduced projection that omits optional fields.
      final msg = e.toString();
      if (msg.contains("Could not find the 'age' column") || msg.contains('column "age"')) {
        try {
          final safeSel = 'id,name,initials,gender,account_id,updated_at,deleted_at,last_writer_device_id';
          var safeQuery = _client.from(_table).select(safeSel);
          if (since > 0) safeQuery = safeQuery.gt('updated_at', DateTime.fromMillisecondsSinceEpoch(since).toUtc().toIso8601String());
          final response = await safeQuery.order('updated_at', ascending: true);
          return (response as List).map((json) => _fromJson(json)).toList();
        } catch (e2) {
          // ignore: avoid_print
          print('[ProfileRemote] fallback query failed: $e2');
          return <ProfileTableData>[];
        }
      }

      // ignore: avoid_print
      print('[ProfileRemote] fetchDelta error: $e');
      return <ProfileTableData>[];
    }
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
      updatedAt: _tsToMillis(json['updated_at']) ?? 0,
      deletedAt: _tsToMillis(json['deleted_at']),
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
      'updated_at': _tsToIso(data.updatedAt),
      'deleted_at': _tsToIso(data.deletedAt),
      'last_writer_device_id': data.lastWriterDeviceId,
    };
  }

  int? _tsToMillis(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) {
      final dt = DateTime.tryParse(v);
      if (dt != null) return dt.millisecondsSinceEpoch;
      return int.tryParse(v);
    }
    return null;
  }

  String? _tsToIso(dynamic v) {
    if (v == null) return null;
    if (v is int) {
      if (v <= 0) return null;
      return DateTime.fromMillisecondsSinceEpoch(v).toUtc().toIso8601String();
    }
    if (v is String) {
      return v;
    }
    return null;
  }
}
