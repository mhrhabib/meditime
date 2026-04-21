import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DoseLogTableData')
class DoseLogTable extends Table {
  TextColumn get id => text()();
  TextColumn get medicineId => text().references(MedicineTable, #id)();
  TextColumn get medicineName => text()();
  DateTimeColumn get logDateTime =>
      dateTime()(); // Renamed to avoid clash with Table.dateTime()
  IntColumn get status => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get scheduledDateTime => dateTime().nullable()();

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
  ReminderSettingsTable
])
class AppDatabase extends _$AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();

  AppDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 4;

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
        },
      );

  // ── Helper Methods ───────────────────────────────────────────────

  // Medicines
  Future<List<MedicineTableData>> getAllMedicines() =>
      select(medicineTable).get();
  Stream<List<MedicineTableData>> watchAllMedicines() =>
      select(medicineTable).watch();
  Future insertMedicine(MedicineTableData med) =>
      into(medicineTable).insert(med, mode: InsertMode.insertOrReplace);
  Future deleteMedicine(String id) =>
      (delete(medicineTable)..where((t) => t.id.equals(id))).go();

  // Profiles
  Future<List<ProfileTableData>> getAllProfiles() => select(profileTable).get();
  Future insertProfile(ProfileTableData pro) =>
      into(profileTable).insert(pro, mode: InsertMode.insertOrReplace);

  // DoseLogs
  Future<List<DoseLogTableData>> getAllDoseLogs() => select(doseLogTable).get();
  Stream<List<DoseLogTableData>> watchAllDoseLogs() =>
      select(doseLogTable).watch();
  Future insertDoseLog(DoseLogTableData log) =>
      into(doseLogTable).insert(log, mode: InsertMode.insertOrReplace);

  // Emergency Card
  Future<EmergencyCardTableData?> getEmergencyCard() =>
      select(emergencyCardTable).getSingleOrNull();
  Future saveEmergencyCard(EmergencyCardTableData data) =>
      into(emergencyCardTable).insert(data, mode: InsertMode.insertOrReplace);

  // Prescriptions
  Future<List<PrescriptionTableData>> getAllPrescriptions() =>
      select(prescriptionTable).get();
  Future insertPrescription(PrescriptionTableData rx) =>
      into(prescriptionTable).insert(rx, mode: InsertMode.insertOrReplace);

  // Reminder Settings
  Future<ReminderSettingsTableData?> getReminderSettings() =>
      select(reminderSettingsTable).getSingleOrNull();
  Future saveReminderSettings(ReminderSettingsTableData settings) =>
      into(reminderSettingsTable)
          .insert(settings, mode: InsertMode.insertOrReplace);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'meditime.sqlite'));
    return NativeDatabase(file);
  });
}
