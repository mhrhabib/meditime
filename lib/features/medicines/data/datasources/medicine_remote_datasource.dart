import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meditime/core/storage/app_database.dart';

abstract class MedicineRemoteDataSource {
  Future<List<MedicineTableData>> fetchDelta(int since);
  Future<void> push(MedicineTableData medicine);
}

class MedicineRemoteDataSourceImpl implements MedicineRemoteDataSource {
  final _client = Supabase.instance.client;
  static const _table = 'medicines';

  @override
  Future<List<MedicineTableData>> fetchDelta(int since) async {
    // If `since` is zero or negative, fetch everything (no gt filter).
    var query = _client.from(_table).select();
    if (since > 0) {
      final sinceIso = DateTime.fromMillisecondsSinceEpoch(since).toUtc().toIso8601String();
      query = query.gt('updated_at', sinceIso);
    }
    final response = await query.order('updated_at', ascending: true);

    return (response as List).map((json) => _fromJson(json)).toList();
  }

  @override
  Future<void> push(MedicineTableData medicine) async {
    await _client.from(_table).upsert(_toJson(medicine));
  }

  MedicineTableData _fromJson(Map<String, dynamic> json) {
    return MedicineTableData(
      id: json['id'],
      profileId: json['profile_id'],
      name: json['name'],
      type: json['type'],
      schedule: json['schedule'],
      stockRemaining: json['stock_remaining'],
      stockTotal: json['stock_total'],
      daysLeft: json['days_left'],
      isLowStock: json['is_low_stock'],
      // image_path is a device-local filesystem path — not portable across
      // devices / reinstalls. Ignore what the server sent; leave any existing
      // local value intact by passing null so the Drift column stays null here
      // and the local-side upsert handles merge (see conflict resolver).
      imagePath: null,
      amount: (json['amount'] as num).toDouble(),
      strength: json['strength'],
      unit: json['unit'],
      reminderTimes: json['reminder_times'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      durationDays: json['duration_days'],
      // sync
      accountId: json['account_id'],
      updatedAt: _tsToMillis(json['updated_at']) ?? 0,
      deletedAt: _tsToMillis(json['deleted_at']),
      dirty: false, // remote data is clean by definition
      lastWriterDeviceId: json['last_writer_device_id'],
    );
  }

  Map<String, dynamic> _toJson(MedicineTableData data) {
    return {
      'id': data.id,
      'profile_id': data.profileId,
      'name': data.name,
      'type': data.type,
      'schedule': data.schedule,
      'stock_remaining': data.stockRemaining,
      'stock_total': data.stockTotal,
      'days_left': data.daysLeft,
      'is_low_stock': data.isLowStock,
      // image_path is device-local — don't push it. Storing in Supabase
      // Storage (with a public URL) would be the proper cross-device fix.
      'image_path': null,
      'amount': data.amount,
      'strength': data.strength,
      'unit': data.unit,
      'reminder_times': data.reminderTimes,
      'start_date': data.startDate?.toUtc().toIso8601String(),
      'duration_days': data.durationDays,
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
      // assume already ISO
      return v;
    }
    return null;
  }
}
