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
    final response = await _client
        .from(_table)
        .select()
        .gt('updated_at', since)
        .order('updated_at', ascending: true);

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
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
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
      'updated_at': data.updatedAt,
      'deleted_at': data.deletedAt,
      'last_writer_device_id': data.lastWriterDeviceId,
    };
  }
}
