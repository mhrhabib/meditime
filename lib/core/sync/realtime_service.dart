import 'dart:async';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meditime/core/storage/app_database.dart';
import 'package:meditime/core/device/device_identity.dart';
import 'package:meditime/features/medicines/data/medicine_scheduler.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';
import 'package:flutter/material.dart';
import 'package:meditime/core/sync/conflict_resolver.dart';

/// Simple realtime sync bridge: subscribes to Supabase realtime events
/// for the core tables and merges remote rows into the local Drift DB.
class RealtimeService {
  RealtimeService._();
  static final instance = RealtimeService._();

  final _client = Supabase.instance.client;
  final _db = AppDatabase.instance;
  final Map<String, dynamic> _subs = {};

  bool get isRunning => _subs.isNotEmpty;

  /// Start subscriptions scoped to [userId]. Existing subscriptions are cleared.
  Future<void> start(String userId) async {
    await stop();
    if (userId.isEmpty) return;

    _subscribe('profiles', userId);
    _subscribe('medicines', userId);
    _subscribe('dose_logs', userId);
    _subscribe('prescriptions', userId);

    debugPrint('[RealtimeService] Subscribed realtime for $userId');
  }

  /// Unsubscribe everything.
  Future<void> stop() async {
    for (final sub in _subs.values) {
      try {
        (sub as dynamic).unsubscribe();
      } catch (_) {}
    }
    _subs.clear();
    debugPrint('[RealtimeService] Stopped realtime subscriptions');
  }

  void _subscribe(String table, String userId) {
    // Use dynamic channel API to avoid strict SDK type coupling here.
    try {
      final dynamic channel = _client.channel('realtime:$table:$userId');

      // Listen to postgres changes for this table filtered by account_id
      channel.on('postgres_changes',
          {'event': '*', 'schema': 'public', 'table': table, 'filter': 'account_id=eq.$userId'},
          (payload, [ref]) => _handleEvent(table, payload['event'] ?? 'UPDATE', payload));

      channel.subscribe();
      _subs[table] = channel;
    } catch (e) {
      debugPrint('[RealtimeService] Failed to subscribe $table: $e');
    }
  }

  Future<void> _handleEvent(String table, String event, dynamic payload) async {
    try {
      final Map<String, dynamic>? newRow = payload?['new'];
      final Map<String, dynamic>? oldRow = payload?['old'];
      final String? eventType = payload?['event'] as String?;

      if (event == 'DELETE' || eventType == 'DELETE') {
        // Apply soft-delete (set deletedAt from remote) if present
        final remote = oldRow;
        if (remote == null) return;
        final id = remote['id'] as String?;
        if (id == null) return;

        final now = DateTime.now().millisecondsSinceEpoch;
        // Insert a tombstone locally
        switch (table) {
          case 'profiles':
              final local = await (_db.select(_db.profileTable)..where((t) => t.id.equals(id))).getSingleOrNull();
              final remoteUpdated = _remoteUpdatedAtMillis(remote['updated_at'], now);
              if (shouldUpdateLocal(local?.updatedAt, local?.lastWriterDeviceId, remoteUpdated, remote['last_writer_device_id'] as String?)) {
                await _db.insertProfile(ProfileTableData(
                  id: id,
                  name: remote['name'] ?? '',
                  initials: remote['initials'] ?? '',
                  age: remote['age'] as int?,
                  gender: remote['gender'] as String?,
                  accountId: remote['account_id'] as String?,
                  updatedAt: remoteUpdated,
                  deletedAt: remote['deleted_at'] ?? now,
                  dirty: false,
                  lastWriterDeviceId: remote['last_writer_device_id'] as String?,
                ));
              }
            break;
          case 'medicines':
              final localMed = await _db.getMedicineById(id);
              final remoteUpdatedMed = _remoteUpdatedAtMillis(remote['updated_at'], now);
              if (shouldUpdateLocal(localMed?.updatedAt, localMed?.lastWriterDeviceId, remoteUpdatedMed, remote['last_writer_device_id'] as String?)) {
                await _db.insertMedicine(MedicineTableData(
                  id: id,
                  profileId: remote['profile_id'] as String?,
                  name: remote['name'] ?? '',
                  type: remote['type'] ?? '',
                  schedule: remote['schedule'] ?? '',
                  stockRemaining: (remote['stock_remaining'] as int?) ?? 0,
                  stockTotal: (remote['stock_total'] as int?) ?? 0,
                  daysLeft: (remote['days_left'] as int?) ?? 0,
                  isLowStock: remote['is_low_stock'] == true,
                  imagePath: remote['image_path'] as String?,
                  amount: (remote['amount'] as num?)?.toDouble() ?? 1.0,
                  strength: remote['strength'] as String?,
                  unit: remote['unit'] as String?,
                  reminderTimes: remote['reminder_times'] as String?,
                  accountId: remote['account_id'] as String?,
                  updatedAt: remoteUpdatedMed,
                  deletedAt: remote['deleted_at'] ?? now,
                  dirty: false,
                  lastWriterDeviceId: remote['last_writer_device_id'] as String?,
                ));
              }
            break;
          case 'dose_logs':
              final localLog = await (_db.select(_db.doseLogTable)..where((t) => t.id.equals(id))).getSingleOrNull();
              final remoteUpdatedLog = _remoteUpdatedAtMillis(remote['updated_at'], now);
              if (shouldUpdateLocal(localLog?.updatedAt, localLog?.lastWriterDeviceId, remoteUpdatedLog, remote['last_writer_device_id'] as String?)) {
                await _db.insertDoseLog(DoseLogTableData(
                  id: id,
                  medicineId: remote['medicine_id'] as String,
                  medicineName: remote['medicine_name'] ?? '',
                  logDateTime: DateTime.tryParse(remote['log_date_time'] ?? '') ?? DateTime.now(),
                  status: remote['status'] as int? ?? 0,
                  note: remote['note'] as String?,
                  scheduledDateTime: remote['scheduled_date_time'] != null ? DateTime.tryParse(remote['scheduled_date_time']) : null,
                  accountId: remote['account_id'] as String?,
                  profileId: remote['profile_id'] as String?,
                  updatedAt: remoteUpdatedLog,
                  deletedAt: remote['deleted_at'] ?? now,
                  dirty: false,
                  lastWriterDeviceId: remote['last_writer_device_id'] as String?,
                ));
              }
            break;
          case 'prescriptions':
              final localRx = await (_db.select(_db.prescriptionTable)..where((t) => t.id.equals(id))).getSingleOrNull();
              final remoteUpdatedRx = _remoteUpdatedAtMillis(remote['updated_at'], now);
              if (shouldUpdateLocal(localRx?.updatedAt, localRx?.lastWriterDeviceId, remoteUpdatedRx, remote['last_writer_device_id'] as String?)) {
                await _db.insertPrescription(PrescriptionTableData(
                  id: id,
                  doctorName: remote['doctor_name'] ?? '',
                  date: DateTime.tryParse(remote['date'] ?? '') ?? DateTime.now(),
                  reason: remote['reason'] ?? '',
                  imageUrl: remote['image_url'] as String?,
                  medicines: remote['medicines'] ?? '',
                  isScanned: remote['is_scanned'] == true,
                  accountId: remote['account_id'] as String?,
                  profileId: remote['profile_id'] as String?,
                  updatedAt: remoteUpdatedRx,
                  deletedAt: remote['deleted_at'] ?? now,
                  dirty: false,
                  lastWriterDeviceId: remote['last_writer_device_id'] as String?,
                ));
              }
            break;
        }

        return;
      }

      // INSERT / UPDATE pathways use the 'new' row
      final remote = newRow;
      if (remote == null) return;

      final now = DateTime.now().millisecondsSinceEpoch;

      switch (table) {
        case 'profiles':
            final id = remote['id'] as String?;
            if (id == null) return;
            final local = await (_db.select(_db.profileTable)..where((t) => t.id.equals(id))).getSingleOrNull();
            final remoteUpdated = _remoteUpdatedAtMillis(remote['updated_at'], now);
            if (shouldUpdateLocal(local?.updatedAt, local?.lastWriterDeviceId, remoteUpdated, remote['last_writer_device_id'] as String?)) {
              await _db.insertProfile(ProfileTableData(
                id: remote['id'],
                name: remote['name'] ?? '',
                initials: remote['initials'] ?? '',
                age: remote['age'] as int?,
                gender: remote['gender'] as String?,
                accountId: remote['account_id'] as String?,
                updatedAt: remoteUpdated,
                deletedAt: remote['deleted_at'] as int?,
                dirty: false,
                lastWriterDeviceId: remote['last_writer_device_id'] as String?,
              ));
            }
          break;
        case 'medicines':
            final id = remote['id'] as String?;
            if (id == null) return;
            final localMed = await _db.getMedicineById(id);
            final remoteUpdatedMed = _remoteUpdatedAtMillis(remote['updated_at'], now);
            if (shouldUpdateLocal(localMed?.updatedAt, localMed?.lastWriterDeviceId, remoteUpdatedMed, remote['last_writer_device_id'] as String?)) {
              await _db.insertMedicine(MedicineTableData(
                id: remote['id'],
                profileId: remote['profile_id'] as String?,
                name: remote['name'] ?? '',
                type: remote['type'] ?? '',
                schedule: remote['schedule'] ?? '',
                stockRemaining: (remote['stock_remaining'] as int?) ?? 0,
                stockTotal: (remote['stock_total'] as int?) ?? 0,
                daysLeft: (remote['days_left'] as int?) ?? 0,
                isLowStock: remote['is_low_stock'] == true,
                imagePath: remote['image_path'] as String?,
                amount: (remote['amount'] as num?)?.toDouble() ?? 1.0,
                strength: remote['strength'] as String?,
                unit: remote['unit'] as String?,
                reminderTimes: remote['reminder_times'] as String?,
                accountId: remote['account_id'] as String?,
                updatedAt: remoteUpdatedMed,
                deletedAt: remote['deleted_at'] as int?,
                dirty: false,
                lastWriterDeviceId: remote['last_writer_device_id'] as String?,
              ));
            }
          break;
        case 'dose_logs':
            final entryId = remote['id'] as String?;
            if (entryId == null) return;
            final localLog = await (_db.select(_db.doseLogTable)..where((t) => t.id.equals(entryId))).getSingleOrNull();
            final remoteUpdatedLog = _remoteUpdatedAtMillis(remote['updated_at'], now);
            final entry = DoseLogTableData(
              id: remote['id'],
              medicineId: remote['medicine_id'] as String,
              medicineName: remote['medicine_name'] ?? '',
              logDateTime: DateTime.tryParse(remote['log_date_time'] ?? '') ?? DateTime.now(),
              status: remote['status'] as int? ?? 0,
              note: remote['note'] as String?,
              scheduledDateTime: remote['scheduled_date_time'] != null ? DateTime.tryParse(remote['scheduled_date_time']) : null,
              accountId: remote['account_id'] as String?,
              profileId: remote['profile_id'] as String?,
              updatedAt: remoteUpdatedLog,
              deletedAt: remote['deleted_at'] as int?,
              dirty: false,
              lastWriterDeviceId: remote['last_writer_device_id'] as String?,
            );

            if (shouldUpdateLocal(localLog?.updatedAt, localLog?.lastWriterDeviceId, remoteUpdatedLog, remote['last_writer_device_id'] as String?)) {
              await _db.insertDoseLog(entry);
            }

          // Cross-device cancel: if another device logged a taken/skipped dose,
          // ensure local notifications/alarms for that scheduled slot are cancelled.
          try {
            final remoteDev = remote['last_writer_device_id'] as String?;
            final localDev = DeviceIdentity.cachedId;
            if ((remoteDev ?? '') != (localDev)) {
              await _maybeCancelNotificationsForDose(entry);
            }
          } catch (_) {}

          break;
        case 'prescriptions':
          final rxId = remote['id'] as String?;
          if (rxId == null) return;
          final localRx = await (_db.select(_db.prescriptionTable)..where((t) => t.id.equals(rxId))).getSingleOrNull();
          final remoteUpdatedRx = _remoteUpdatedAtMillis(remote['updated_at'], now);
          if (shouldUpdateLocal(localRx?.updatedAt, localRx?.lastWriterDeviceId, remoteUpdatedRx, remote['last_writer_device_id'] as String?)) {
            await _db.insertPrescription(PrescriptionTableData(
              id: remote['id'],
              doctorName: remote['doctor_name'] ?? '',
              date: DateTime.tryParse(remote['date'] ?? '') ?? DateTime.now(),
              reason: remote['reason'] ?? '',
              imageUrl: remote['image_url'] as String?,
              medicines: remote['medicines'] ?? '',
              isScanned: remote['is_scanned'] == true,
              accountId: remote['account_id'] as String?,
              profileId: remote['profile_id'] as String?,
              updatedAt: remoteUpdatedRx,
              deletedAt: remote['deleted_at'] as int?,
              dirty: false,
              lastWriterDeviceId: remote['last_writer_device_id'] as String?,
            ));
          }
          break;
      }
    } catch (e, st) {
      debugPrint('[RealtimeService] Event handler error: $e');
      debugPrint(st.toString());
    }
  }

  Future<void> _maybeCancelNotificationsForDose(DoseLogTableData entry) async {
    // If we have a scheduledDateTime, try to find the matching medicine
    // and cancel the notification(s) for that scheduled slot on this device.
    final med = await _db.getMedicineById(entry.medicineId);
    if (med == null) return;

    // Convert table data into domain `Medicine` to reuse scheduler logic.
    final medicineDomain = _medicineTableToDomain(med);
    // If the remote entry includes a scheduledDateTime, try to compute the
    // exact dose index for that day so we only cancel the matching
    // notification/alarm rather than every notification for the medicine.
    final scheduled = entry.scheduledDateTime;
    if (scheduled == null) {
      debugPrint('[RealtimeService] Remote dose ${entry.id} has no scheduledDateTime — cancelling all notifications for medicine ${medicineDomain.id}');
      await MedicineScheduler.cancelForMedicine(medicineDomain);
      return;
    }

    try {
      final doseTimes = MedicineScheduler.doseTimesForMedicine(medicineDomain);
      if (doseTimes.isEmpty) {
        await MedicineScheduler.cancelForMedicine(medicineDomain);
        return;
      }

      final target = Duration(hours: scheduled.hour, minutes: scheduled.minute, seconds: scheduled.second);

      // Match by nearest time-of-day within a small tolerance (2 minutes)
      const toleranceSeconds = 120;
      int? matchedIdx;
      for (int i = 0; i < doseTimes.length; i++) {
        final diff = (doseTimes[i] - target).inSeconds.abs();
        if (diff <= toleranceSeconds) {
          matchedIdx = i;
          break;
        }
      }

      if (matchedIdx != null) {
        debugPrint('[RealtimeService] Matched dose index $matchedIdx for medicine ${medicineDomain.id} at $scheduled — cancelling exact dose');
        await MedicineScheduler.cancelDose(
          medicineId: medicineDomain.id,
          doseIdx: matchedIdx,
          scheduledTime: scheduled,
        );
        return;
      }
    } catch (_) {}

    // Fallback: cancel all for the medicine if we couldn't determine an index
    try {
      final timesStr = (MedicineScheduler.doseTimesForMedicine(medicineDomain)
              .map((d) => d.toString())
              .join(', '));
      debugPrint('[RealtimeService] Could not match scheduled time $scheduled to doseTimes [$timesStr] for medicine ${medicineDomain.id}; falling back to cancel all');
    } catch (_) {
      debugPrint('[RealtimeService] Could not match scheduled time $scheduled for medicine ${medicineDomain.id}; falling back to cancel all');
    }

    await MedicineScheduler.cancelForMedicine(medicineDomain);
  }

  int _remoteUpdatedAtMillis(dynamic val, int fallback) {
    if (val == null) return fallback;
    if (val is int) return val;
    if (val is String) {
      try {
        final dt = DateTime.tryParse(val);
        if (dt != null) return dt.millisecondsSinceEpoch;
        return int.tryParse(val) ?? fallback;
      } catch (_) {
        return fallback;
      }
    }
    return fallback;
  }

  Medicine _medicineTableToDomain(MedicineTableData med) {
    List<TimeOfDay> times = [];
    try {
      if (med.reminderTimes != null && med.reminderTimes!.isNotEmpty) {
        final decoded = json.decode(med.reminderTimes!);
        if (decoded is List) {
          times = decoded.map<TimeOfDay>((e) {
            final hour = (e['hour'] as int?) ?? 0;
            final minute = (e['minute'] as int?) ?? 0;
            return TimeOfDay(hour: hour, minute: minute);
          }).toList();
        }
      }
    } catch (_) {}

    return Medicine(
      id: med.id,
      profileId: med.profileId,
      name: med.name,
      type: med.type,
      schedule: med.schedule,
      stockRemaining: med.stockRemaining,
      stockTotal: med.stockTotal,
      daysLeft: med.daysLeft,
      isLowStock: med.isLowStock,
      imagePath: med.imagePath,
      amount: med.amount,
      strength: med.strength,
      unit: med.unit,
      times: times,
    );
  }
}
