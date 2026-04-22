import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:meditime/core/device/device_identity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ── Tables ─────────────────────────────────────────────────────────

@DataClassName('ProfileTableData')
class ProfileTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get initials => text()();
  IntColumn get age => integer().nullable()();
  TextColumn get gender => text().nullable()();

  // ── Sync columns (v5) ──
  TextColumn get accountId => text().nullable()();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  IntColumn get deletedAt => integer().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  TextColumn get lastWriterDeviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MedicineTableData')
class MedicineTable extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text().nullable().references(ProfileTable, #id)();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get schedule => text()();
  IntColumn get stockRemaining => integer()();
  IntColumn get stockTotal => integer()();
  IntColumn get daysLeft => integer()();
  BoolColumn get isLowStock => boolean()();
  TextColumn get imagePath => text().nullable()();
  RealColumn get amount => real().withDefault(const Constant(1.0))();
  TextColumn get strength => text().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get reminderTimes => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  IntColumn get durationDays => integer().nullable()();

  // ── Sync columns (v5) ──
  TextColumn get accountId => text().nullable()();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  IntColumn get deletedAt => integer().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  TextColumn get lastWriterDeviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DoseLogTableData')
class DoseLogTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text().references(MedicineTable, #id)();
  TextColumn get medicineName => text()();
  DateTimeColumn get logDateTime => dateTime()();
  IntColumn get status => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get scheduledDateTime => dateTime().nullable()();

  // ── Sync columns (v5) ──
  TextColumn get accountId => text().nullable()();
  TextColumn get profileId => text().nullable()();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  IntColumn get deletedAt => integer().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  TextColumn get lastWriterDeviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EmergencyCardTableData')
class EmergencyCardTable extends Table {
  TextColumn get id => text().withDefault(const Constant('primary'))();
  TextColumn get fullName => text()();
  TextColumn get bloodType => text()();
  TextColumn get allergies => text()();
  TextColumn get conditions => text()();
  TextColumn get emergencyContactName => text()();
  TextColumn get emergencyContactPhone => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('PrescriptionTableData')
class PrescriptionTable extends Table {
  TextColumn get id => text()();
  TextColumn get doctorName => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get reason => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get medicines => text()();
  BoolColumn get isScanned => boolean().withDefault(const Constant(false))();

  // ── Sync columns (v5) ──
  TextColumn get accountId => text().nullable()();
  TextColumn get profileId => text().nullable()();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();
  IntColumn get deletedAt => integer().nullable()();
  BoolColumn get dirty => boolean().withDefault(const Constant(true))();
  TextColumn get lastWriterDeviceId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReminderSettingsTableData')
class ReminderSettingsTable extends Table {
  TextColumn get id => text().withDefault(const Constant('primary'))();
  BoolColumn get enableNotifications =>
      boolean().withDefault(const Constant(true))();
  IntColumn get snoozeDurationMinutes =>
      integer().withDefault(const Constant(10))();
  TextColumn get notificationSound =>
      text().withDefault(const Constant('default'))();
  BoolColumn get criticalAlerts =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ───────────────────────────────────────────────────────

@DriftDatabase(tables: [
  ProfileTable,
  MedicineTable,
  DoseLogTable,
  EmergencyCardTable,
  PrescriptionTable,
  ReminderSettingsTable,
])
class AppDatabase extends _$AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();

  AppDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(medicineTable, medicineTable.imagePath);
            await m.addColumn(medicineTable, medicineTable.amount);
            await m.addColumn(medicineTable, medicineTable.strength);
            await m.addColumn(medicineTable, medicineTable.unit);
          }
          if (from < 3) {
            await m.addColumn(medicineTable, medicineTable.reminderTimes);
            await m.addColumn(doseLogTable, doseLogTable.scheduledDateTime);
          }
          if (from < 4) {
            await m.addColumn(profileTable, profileTable.age);
            await m.addColumn(profileTable, profileTable.gender);
          }
          if (from < 5) {
            // Profiles
            await m.addColumn(profileTable, profileTable.accountId);
            await m.addColumn(profileTable, profileTable.updatedAt);
            await m.addColumn(profileTable, profileTable.deletedAt);
            await m.addColumn(profileTable, profileTable.dirty);
            await m.addColumn(
                profileTable, profileTable.lastWriterDeviceId);

            // Medicines
            await m.addColumn(medicineTable, medicineTable.accountId);
            await m.addColumn(medicineTable, medicineTable.updatedAt);
            await m.addColumn(medicineTable, medicineTable.deletedAt);
            await m.addColumn(medicineTable, medicineTable.dirty);
            await m.addColumn(
                medicineTable, medicineTable.lastWriterDeviceId);

            // Dose logs
            await m.addColumn(doseLogTable, doseLogTable.accountId);
            await m.addColumn(doseLogTable, doseLogTable.profileId);
            await m.addColumn(doseLogTable, doseLogTable.updatedAt);
            await m.addColumn(doseLogTable, doseLogTable.deletedAt);
            await m.addColumn(doseLogTable, doseLogTable.dirty);
            await m.addColumn(
                doseLogTable, doseLogTable.lastWriterDeviceId);

            // Prescriptions
            await m.addColumn(prescriptionTable, prescriptionTable.accountId);
            await m.addColumn(prescriptionTable, prescriptionTable.profileId);
            await m.addColumn(prescriptionTable, prescriptionTable.updatedAt);
            await m.addColumn(prescriptionTable, prescriptionTable.deletedAt);
            await m.addColumn(prescriptionTable, prescriptionTable.dirty);
            await m.addColumn(
                prescriptionTable, prescriptionTable.lastWriterDeviceId);
          }
          if (from < 6) {
            await m.addColumn(medicineTable, medicineTable.startDate);
            await m.addColumn(medicineTable, medicineTable.durationDays);
          }
        },
      );

  // ── Helper Methods ───────────────────────────────────────────────

  // Medicines
  Future<List<MedicineTableData>> getAllMedicines() =>
      (select(medicineTable)..where((t) => t.deletedAt.isNull())).get();
  Stream<List<MedicineTableData>> watchAllMedicines() =>
      (select(medicineTable)..where((t) => t.deletedAt.isNull())).watch();
  Future<MedicineTableData?> getMedicineById(String id) =>
      (select(medicineTable)..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();

  Future insertMedicine(MedicineTableData med) =>
      into(medicineTable).insert(med, mode: InsertMode.insertOrReplace);

  Future softDeleteMedicine(String id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final deviceId = (await _getDeviceId());
    return (update(medicineTable)..where((t) => t.id.equals(id))).write(
      MedicineTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        dirty: const Value(true),
        lastWriterDeviceId: Value(deviceId),
      ),
    );
  }

  Future<List<MedicineTableData>> getDirtyMedicines() =>
      (select(medicineTable)..where((t) => t.dirty.equals(true))).get();

  // Profiles
  Future<List<ProfileTableData>> getAllProfiles() =>
      (select(profileTable)..where((t) => t.deletedAt.isNull())).get();
  Stream<List<ProfileTableData>> watchAllProfiles() =>
      (select(profileTable)..where((t) => t.deletedAt.isNull())).watch();
  Future insertProfile(ProfileTableData pro) =>
      into(profileTable).insert(pro, mode: InsertMode.insertOrReplace);
  
  Future softDeleteProfile(String id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final deviceId = (await _getDeviceId());
    return (update(profileTable)..where((t) => t.id.equals(id))).write(
      ProfileTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        dirty: const Value(true),
        lastWriterDeviceId: Value(deviceId),
      ),
    );
  }

  Future<List<ProfileTableData>> getDirtyProfiles() =>
      (select(profileTable)..where((t) => t.dirty.equals(true))).get();

  // DoseLogs
  Future<List<DoseLogTableData>> getAllDoseLogs() =>
      (select(doseLogTable)..where((t) => t.deletedAt.isNull())).get();
  Stream<List<DoseLogTableData>> watchAllDoseLogs() =>
      (select(doseLogTable)..where((t) => t.deletedAt.isNull())).watch();
  Future insertDoseLog(DoseLogTableData log) =>
      into(doseLogTable).insert(log, mode: InsertMode.insertOrReplace);
  
  Future softDeleteDoseLog(String id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final deviceId = (await _getDeviceId());
    return (update(doseLogTable)..where((t) => t.id.equals(id))).write(
      DoseLogTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        dirty: const Value(true),
        lastWriterDeviceId: Value(deviceId),
      ),
    );
  }

  Future<List<DoseLogTableData>> getDirtyDoseLogs() =>
      (select(doseLogTable)..where((t) => t.dirty.equals(true))).get();

  // Emergency Card
  Future<EmergencyCardTableData?> getEmergencyCard() =>
      select(emergencyCardTable).getSingleOrNull();
  Future saveEmergencyCard(EmergencyCardTableData data) =>
      into(emergencyCardTable).insert(data, mode: InsertMode.insertOrReplace);

  // Prescriptions
  Future<List<PrescriptionTableData>> getAllPrescriptions() =>
      (select(prescriptionTable)..where((t) => t.deletedAt.isNull())).get();
  Stream<List<PrescriptionTableData>> watchAllPrescriptions() =>
      (select(prescriptionTable)..where((t) => t.deletedAt.isNull())).watch();
  Future insertPrescription(PrescriptionTableData rx) =>
      into(prescriptionTable).insert(rx, mode: InsertMode.insertOrReplace);
  
  Future softDeletePrescription(String id) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final deviceId = (await _getDeviceId());
    return (update(prescriptionTable)..where((t) => t.id.equals(id))).write(
      PrescriptionTableCompanion(
        deletedAt: Value(now),
        updatedAt: Value(now),
        dirty: const Value(true),
        lastWriterDeviceId: Value(deviceId),
      ),
    );
  }

  Future<List<PrescriptionTableData>> getDirtyPrescriptions() =>
      (select(prescriptionTable)..where((t) => t.dirty.equals(true))).get();

  // Reminder Settings
  Future<ReminderSettingsTableData?> getReminderSettings() =>
      select(reminderSettingsTable).getSingleOrNull();
  Future saveReminderSettings(ReminderSettingsTableData settings) =>
      into(reminderSettingsTable)
          .insert(settings, mode: InsertMode.insertOrReplace);

  // ── Sync helpers ─────────────────────────────────────────────────

  Future<String> _getDeviceId() async {
    return (await DeviceIdentity.id);
  }

  Future<void> markMedicineClean(String id) => (update(medicineTable)
        ..where((t) => t.id.equals(id)))
      .write(const MedicineTableCompanion(dirty: Value(false)));

  Future<void> markProfileClean(String id) => (update(profileTable)
        ..where((t) => t.id.equals(id)))
      .write(const ProfileTableCompanion(dirty: Value(false)));

  Future<void> markDoseLogClean(String id) => (update(doseLogTable)
        ..where((t) => t.id.equals(id)))
      .write(const DoseLogTableCompanion(dirty: Value(false)));

  Future<void> markPrescriptionClean(String id) => (update(prescriptionTable)
        ..where((t) => t.id.equals(id)))
      .write(const PrescriptionTableCompanion(dirty: Value(false)));

  /// Backfills accountId for all rows that don't have it.
  /// Called after successful login to claim existing local data.
  Future<void> backfillAccountId(String accountId) async {
    await batch((batch) {
      batch.update(medicineTable, MedicineTableCompanion(accountId: Value(accountId)),
          where: (t) => t.accountId.isNull());
      batch.update(profileTable, ProfileTableCompanion(accountId: Value(accountId)),
          where: (t) => t.accountId.isNull());
      batch.update(doseLogTable, DoseLogTableCompanion(accountId: Value(accountId)),
          where: (t) => t.accountId.isNull());
      batch.update(prescriptionTable, PrescriptionTableCompanion(accountId: Value(accountId)),
          where: (t) => t.accountId.isNull());
    });
  }

  /// Repairs missing profileIds for dose logs and prescriptions.
  /// This is critical for sync to succeed when legacy data is present.
  Future<void> repairMissingSyncData() async {
    // 1. Repair DoseLogs (join with medicines to find profileId)
    final logsWithMissingProfile = await (select(doseLogTable)
          ..where((t) => t.profileId.isNull()))
        .get();

    for (final log in logsWithMissingProfile) {
      final med = await getMedicineById(log.medicineId);
      if (med != null && med.profileId != null) {
        await (update(doseLogTable)..where((t) => t.id.equals(log.id))).write(
          DoseLogTableCompanion(profileId: Value(med.profileId)),
        );
      }
    }

    // 2. Repair Prescriptions (if any are missing profileId, use the active one if available)
    // For now, we mainly focus on dose logs as they are the source of current failures.
  }

  /// Clear all user data on sign-out.
  Future<void> clearAllUserData() async {
    await delete(medicineTable).go();
    await delete(profileTable).go();
    await delete(doseLogTable).go();
    await delete(prescriptionTable).go();
    await delete(emergencyCardTable).go();
    await delete(reminderSettingsTable).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'meditime.sqlite'));
    return NativeDatabase(file);
  });
}
