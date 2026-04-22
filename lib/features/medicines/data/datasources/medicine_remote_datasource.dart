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
    //gt means Greater Than. gt('updated_at', since)
    final response = await _client
        .from(_table)
        .select()
        .gt('updated_at', since)
        .order('updated_at', ascending: true);

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
      imagePath: json['image_path'],
      amount: (json['amount'] as num).toDouble(),
      strength: json['strength'],
      unit: json['unit'],
      reminderTimes: json['reminder_times'],
      // sync
      accountId: json['account_id'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
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
      'image_path': data.imagePath,
      'amount': data.amount,
      'strength': data.strength,
      'unit': data.unit,
      'reminder_times': data.reminderTimes,
      // sync
      'account_id': data.accountId,
      'updated_at': data.updatedAt,
      'deleted_at': data.deletedAt,
      'last_writer_device_id': data.lastWriterDeviceId,
    };
  }
}
