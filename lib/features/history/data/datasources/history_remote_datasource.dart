import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meditime/core/storage/app_database.dart';

abstract class HistoryRemoteDataSource {
  Future<List<DoseLogTableData>> fetchDelta(int since);
  Future<void> push(DoseLogTableData log);
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final _client = Supabase.instance.client;
  static const _table = 'dose_logs';

  @override
  Future<List<DoseLogTableData>> fetchDelta(int since) async {
    final response = await _client
        .from(_table)
        .select()
        .gt('updated_at', since)
        .order('updated_at', ascending: true);

    return (response as List).map((json) => _fromJson(json)).toList();
  }

  @override
  Future<void> push(DoseLogTableData log) async {
    await _client.from(_table).upsert(_toJson(log));
  }

  DoseLogTableData _fromJson(Map<String, dynamic> json) {
    return DoseLogTableData(
      id: json['id'],
      medicineId: json['medicine_id'],
      medicineName: json['medicine_name'],
      logDateTime: DateTime.parse(json['log_date_time']),
      status: json['status'],
      note: json['note'],
      scheduledDateTime: json['scheduled_date_time'] != null 
          ? DateTime.parse(json['scheduled_date_time']) 
          : null,
      // sync
      accountId: json['account_id'],
      profileId: json['profile_id'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      dirty: false,
      lastWriterDeviceId: json['last_writer_device_id'],
    );
  }

  Map<String, dynamic> _toJson(DoseLogTableData data) {
    return {
      'id': data.id,
      'medicine_id': data.medicineId,
      'medicine_name': data.medicineName,
      'log_date_time': data.logDateTime.toIso8601String(),
      'status': data.status,
      'note': data.note,
      'scheduled_date_time': data.scheduledDateTime?.toIso8601String(),
      // sync
      'account_id': data.accountId,
      'profile_id': data.profileId,
      'updated_at': data.updatedAt,
      'deleted_at': data.deletedAt,
      'last_writer_device_id': data.lastWriterDeviceId,
    };
  }
}
