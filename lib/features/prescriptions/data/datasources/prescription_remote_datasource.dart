import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meditime/core/storage/app_database.dart';

abstract class PrescriptionRemoteDataSource {
  Future<List<PrescriptionTableData>> fetchDelta(int since);
  Future<void> push(PrescriptionTableData prescription);
}

class PrescriptionRemoteDataSourceImpl implements PrescriptionRemoteDataSource {
  final _client = Supabase.instance.client;
  static const _table = 'prescriptions';

  @override
  Future<List<PrescriptionTableData>> fetchDelta(int since) async {
    var query = _client.from(_table).select();
    if (since > 0) {
      final sinceIso = DateTime.fromMillisecondsSinceEpoch(since).toUtc().toIso8601String();
      query = query.gt('updated_at', sinceIso);
    }
    final response = await query.order('updated_at', ascending: true);

    return (response as List).map((json) => _fromJson(json)).toList();
  }

  @override
  Future<void> push(PrescriptionTableData prescription) async {
    await _client.from(_table).upsert(_toJson(prescription));
  }

  PrescriptionTableData _fromJson(Map<String, dynamic> json) {
    return PrescriptionTableData(
      id: json['id'],
      doctorName: json['doctor_name'],
      date: DateTime.parse(json['date']),
      reason: json['reason'],
      imageUrl: json['image_url'],
      medicines: json['medicines'], // Assuming comma separated string or json
      isScanned: json['is_scanned'],
      // sync
      accountId: json['account_id'],
      profileId: json['profile_id'],
      updatedAt: _tsToMillis(json['updated_at']) ?? 0,
      deletedAt: _tsToMillis(json['deleted_at']),
      dirty: false,
      lastWriterDeviceId: json['last_writer_device_id'],
    );
  }

  Map<String, dynamic> _toJson(PrescriptionTableData data) {
    return {
      'id': data.id,
      'doctor_name': data.doctorName,
      'date': data.date.toIso8601String(),
      'reason': data.reason,
      'image_url': data.imageUrl,
      'medicines': data.medicines,
      'is_scanned': data.isScanned,
      // sync
      'account_id': data.accountId,
      'profile_id': data.profileId,
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
