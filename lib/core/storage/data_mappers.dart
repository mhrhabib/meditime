import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meditime/core/storage/app_database.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';
import 'package:meditime/features/history/domain/entities/dose_log.dart' as entity;
import 'package:meditime/features/profile/domain/entities/profile.dart' as profile_entity;
import 'package:meditime/features/emergency_card/domain/entities/emergencycard.dart';
import 'package:meditime/features/prescriptions/domain/entities/prescription.dart';

class DataMappers {
  // ── Medicine ─────────────────────────────────────────────────────
  static Medicine medicineFromTable(MedicineTableData data) {
    return Medicine(
      id: data.id,
      profileId: data.profileId,
      name: data.name,
      type: data.type,
      schedule: data.schedule,
      stockRemaining: data.stockRemaining,
      stockTotal: data.stockTotal,
      daysLeft: data.daysLeft,
      isLowStock: data.isLowStock,
      imagePath: data.imagePath,
      amount: data.amount,
      strength: data.strength,
      unit: data.unit,
      times: _timeListFromJson(data.reminderTimes),
    );
  }

  static MedicineTableData medicineToTable(Medicine entity) {
    return MedicineTableData(
      id: entity.id,
      profileId: entity.profileId,
      name: entity.name,
      type: entity.type,
      schedule: entity.schedule,
      stockRemaining: entity.stockRemaining,
      stockTotal: entity.stockTotal,
      daysLeft: entity.daysLeft,
      isLowStock: entity.isLowStock,
      imagePath: entity.imagePath,
      amount: entity.amount,
      strength: entity.strength,
      unit: entity.unit,
      reminderTimes: _timeListToJson(entity.times),
    );
  }

  // ── DoseLog ──────────────────────────────────────────────────────
  static entity.DoseLog doseLogFromTable(DoseLogTableData data) {
    return entity.DoseLog(
      id: data.id,
      medicineId: data.medicineId,
      medicineName: data.medicineName,
      dateTime: data.logDateTime,
      status: entity.DoseStatus.values[data.status],
      note: data.note,
      scheduledDateTime: data.scheduledDateTime,
    );
  }

  static DoseLogTableData doseLogToTable(entity.DoseLog data) {
    return DoseLogTableData(
      id: data.id,
      medicineId: data.medicineId,
      medicineName: data.medicineName,
      logDateTime: data.dateTime,
      status: data.status.index,
      note: data.note,
      scheduledDateTime: data.scheduledDateTime,
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────
  static String _timeListToJson(List<TimeOfDay> times) {
    return jsonEncode(times.map((t) => '${t.hour}:${t.minute}').toList());
  }

  static List<TimeOfDay> _timeListFromJson(String? json) {
    if (json == null || json.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(json);
      return list.map((s) {
        final parts = s.split(':');
        return TimeOfDay(
            hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Profile ──────────────────────────────────────────────────────
  static profile_entity.Profile profileFromTable(ProfileTableData data) {
    return profile_entity.Profile(
      id: data.id,
      name: data.name,
      initials: data.initials,
      age: data.age,
      gender: data.gender,
    );
  }

  static ProfileTableData profileToTable(profile_entity.Profile data) {
    return ProfileTableData(
      id: data.id,
      name: data.name,
      initials: data.initials,
      age: data.age,
      gender: data.gender,
    );
  }

  // ── Emergency Card ───────────────────────────────────────────────
  static EmergencyCard emergencyCardFromTable(EmergencyCardTableData data) {
    return EmergencyCard(
      fullName: data.fullName,
      bloodType: data.bloodType,
      allergies: data.allergies,
      conditions: data.conditions,
      emergencyContactName: data.emergencyContactName,
      emergencyContactPhone: data.emergencyContactPhone,
    );
  }

  static EmergencyCardTableData emergencyCardToTable(EmergencyCard data) {
    return EmergencyCardTableData(
      id: 'primary',
      fullName: data.fullName,
      bloodType: data.bloodType,
      allergies: data.allergies,
      conditions: data.conditions,
      emergencyContactName: data.emergencyContactName,
      emergencyContactPhone: data.emergencyContactPhone,
    );
  }

  // ── Prescription ─────────────────────────────────────────────────
  static Prescription prescriptionFromTable(PrescriptionTableData data) {
    return Prescription(
      id: data.id,
      doctorName: data.doctorName,
      date: data.date,
      reason: data.reason,
      imageUrl: data.imageUrl,
      medicines: data.medicines.split(','),
      isScanned: data.isScanned,
    );
  }

  static PrescriptionTableData prescriptionToTable(Prescription data) {
    return PrescriptionTableData(
      id: data.id,
      doctorName: data.doctorName,
      date: data.date,
      reason: data.reason,
      imageUrl: data.imageUrl,
      medicines: data.medicines.join(','),
      isScanned: data.isScanned,
    );
  }
}
