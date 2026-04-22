import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:meditime/core/storage/app_database.dart';
import 'package:meditime/features/history/data/datasources/history_remote_datasource.dart';
import 'package:meditime/features/medicines/data/datasources/medicine_remote_datasource.dart';
import 'package:meditime/features/prescriptions/data/datasources/prescription_remote_datasource.dart';
import 'package:meditime/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Central sync orchestration engine.
///
/// Implements delta-based sync with last-write-wins (updatedAt) 
/// and deterministic tie-breaking (lastWriterDeviceId).
class SyncService {
  SyncService._();
  static final instance = SyncService._();

  final _db = AppDatabase.instance;
  final _medRemote = MedicineRemoteDataSourceImpl();
  final _proRemote = ProfileRemoteDataSourceImpl();
  final _histRemote = HistoryRemoteDataSourceImpl();
  final _rxRemote = PrescriptionRemoteDataSourceImpl();

  static const _lastSyncKey = 'last_sync_timestamp';
  
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Timer? _debounceTimer;

  /// Main entry point. Pulls remote changes then pushes local dirty rows.
  /// [immediate] skips the 3-second debounce.
  Future<void> sync({bool immediate = false}) async {
    if (immediate) {
      _debounceTimer?.cancel();
      await _performSync();
    } else {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(seconds: 3), () => _performSync());
    }
  }

  Future<void> _performSync() async {
    if (_isSyncing) return;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    _isSyncing = true;
    debugPrint('[SyncService] Starting sync for user: $userId');

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastPulledAt = prefs.getInt(_lastSyncKey) ?? 0;
      final syncStartTime = DateTime.now().millisecondsSinceEpoch;

      // 1. Pull Deltas
      await _pull(lastPulledAt);

      // 2. Push Local Dirty Rows
      await _push();

      // 3. Update Sync Timestamp
      await prefs.setInt(_lastSyncKey, syncStartTime);
      
      debugPrint('[SyncService] Sync completed successfully at $syncStartTime');
    } catch (e, stack) {
      debugPrint('[SyncService] Sync failed: $e');
      debugPrint(stack.toString());
    } finally {
      _isSyncing = false;
    }
  }

  // ── Pull Logic ──────────────────────────────────────────────────

  Future<void> _pull(int since) async {
    // Pull profiles first (medicines depend on them)
    final profileDeltas = await _proRemote.fetchDelta(since);
    for (final remote in profileDeltas) {
      final local = await (_db.select(_db.profileTable)..where((t) => t.id.equals(remote.id))).getSingleOrNull();
      if (_shouldUpdateLocal(local?.updatedAt, local?.lastWriterDeviceId, remote.updatedAt, remote.lastWriterDeviceId)) {
        await _db.insertProfile(remote);
      }
    }

    // Pull medicines
    final medicineDeltas = await _medRemote.fetchDelta(since);
    for (final remote in medicineDeltas) {
      final local = await _db.getMedicineById(remote.id);
      if (_shouldUpdateLocal(local?.updatedAt, local?.lastWriterDeviceId, remote.updatedAt, remote.lastWriterDeviceId)) {
        await _db.insertMedicine(remote);
      }
    }

    // Pull dose logs
    final logDeltas = await _histRemote.fetchDelta(since);
    for (final remote in logDeltas) {
      final local = await (_db.select(_db.doseLogTable)..where((t) => t.id.equals(remote.id))).getSingleOrNull();
      if (_shouldUpdateLocal(local?.updatedAt, local?.lastWriterDeviceId, remote.updatedAt, remote.lastWriterDeviceId)) {
        await _db.insertDoseLog(remote);
      }
    }

    // Pull prescriptions
    final rxDeltas = await _rxRemote.fetchDelta(since);
    for (final remote in rxDeltas) {
      final local = await (_db.select(_db.prescriptionTable)..where((t) => t.id.equals(remote.id))).getSingleOrNull();
      if (_shouldUpdateLocal(local?.updatedAt, local?.lastWriterDeviceId, remote.updatedAt, remote.lastWriterDeviceId)) {
        await _db.insertPrescription(remote);
      }
    }
  }

  // ── Push Logic ──────────────────────────────────────────────────

  Future<void> _push() async {
    // Push profiles
    final dirtyProfiles = await _db.getDirtyProfiles();
    for (final p in dirtyProfiles) {
      await _proRemote.push(p);
      await _db.markProfileClean(p.id);
    }

    // Push medicines
    final dirtyMedicines = await _db.getDirtyMedicines();
    for (final m in dirtyMedicines) {
      await _medRemote.push(m);
      await _db.markMedicineClean(m.id);
    }

    // Push dose logs
    final dirtyLogs = await _db.getDirtyDoseLogs();
    for (final l in dirtyLogs) {
      await _histRemote.push(l);
      await _db.markDoseLogClean(l.id);
    }

    // Push prescriptions
    final dirtyRx = await _db.getDirtyPrescriptions();
    for (final r in dirtyRx) {
      await _rxRemote.push(r);
      await _db.markPrescriptionClean(r.id);
    }
  }

  // ── Conflict Resolution ─────────────────────────────────────────

  bool _shouldUpdateLocal(
      int? localUp, String? localDev, int remoteUp, String? remoteDev) {
    if (localUp == null) return true; // New record

    if (remoteUp > localUp) return true; // Remote is strictly newer
    if (remoteUp < localUp) return false; // Local is strictly newer

    // Timestamps Identical: Deterministic tie-break using device ID
    // Higher UUID string wins (standard conflict resolution pattern)
    return (remoteDev ?? '').compareTo(localDev ?? '') > 0;
  }
}
