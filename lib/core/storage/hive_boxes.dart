import 'package:hive_flutter/hive_flutter.dart';
import '../../features/medicines/data/models/medicine_model.dart';
import '../../features/medicines/data/models/dose_event_model.dart';
import '../../features/profile/data/models/profile_model.dart';
import '../../features/prescriptions/data/models/prescription_model.dart';
import '../../features/emergency_card/data/models/emergencycard_model.dart';
import '../../features/reminders/data/models/reminder_settings_model.dart';
import '../../features/medicines/domain/entities/dose_event.dart';

class HiveBoxes {
  static const String medicines = 'medicines';
  static const String doseEvents = 'dose_events';
  static const String profiles = 'profiles';
  static const String prescriptions = 'prescriptions';
  static const String emergencyCard = 'emergency_card';
  static const String reminderSettings = 'reminder_settings';

  static Future<void> openBoxes() async {
    // Register adapters
    Hive.registerAdapter(MedicineModelAdapter());
    Hive.registerAdapter(DoseEventModelAdapter());
    Hive.registerAdapter(DoseStatusAdapter());
    Hive.registerAdapter(ProfileModelAdapter());
    Hive.registerAdapter(PrescriptionModelAdapter());
    Hive.registerAdapter(EmergencyCardModelAdapter());
    Hive.registerAdapter(ReminderSettingsModelAdapter());

    // Open boxes
    await Hive.openBox<MedicineModel>(medicines);
    await Hive.openBox<DoseEventModel>(doseEvents);
    await Hive.openBox<ProfileModel>(profiles);
    await Hive.openBox<PrescriptionModel>(prescriptions);
    await Hive.openBox<EmergencyCardModel>(emergencyCard);
    await Hive.openBox<ReminderSettingsModel>(reminderSettings);
  }
}
