import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Medicine extends Equatable {
  final String id;
  final String? profileId; // Made nullable for backward compatibility
  final String name;
  final String type;
  final String schedule;
  final int stockRemaining;
  final int stockTotal;
  final int daysLeft;
  final bool isLowStock;
  final String? imagePath;
  final double amount;
  final String? strength;
  final String? unit;
  final List<TimeOfDay> times;

  const Medicine({
    required this.id,
    this.profileId = 'me',
    required this.name,
    required this.type,
    required this.schedule,
    required this.stockRemaining,
    required this.stockTotal,
    required this.daysLeft,
    required this.isLowStock,
    this.imagePath,
    this.amount = 1.0,
    this.strength,
    this.unit,
    this.times = const [],
  });

  Medicine copyWith({
    String? id,
    String? profileId,
    String? name,
    String? type,
    String? schedule,
    int? stockRemaining,
    int? stockTotal,
    int? daysLeft,
    bool? isLowStock,
    String? imagePath,
    double? amount,
    String? strength,
    String? unit,
    List<TimeOfDay>? times,
  }) {
    return Medicine(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      name: name ?? this.name,
      type: type ?? this.type,
      schedule: schedule ?? this.schedule,
      stockRemaining: stockRemaining ?? this.stockRemaining,
      stockTotal: stockTotal ?? this.stockTotal,
      daysLeft: daysLeft ?? this.daysLeft,
      isLowStock: isLowStock ?? this.isLowStock,
      imagePath: imagePath ?? this.imagePath,
      amount: amount ?? this.amount,
      strength: strength ?? this.strength,
      unit: unit ?? this.unit,
      times: times ?? this.times,
    );
  }

  @override
  List<Object?> get props => [
        id,
        profileId,
        name,
        type,
        schedule,
        stockRemaining,
        stockTotal,
        daysLeft,
        isLowStock,
        imagePath,
        amount,
        strength,
        unit,
        times,
      ];
}
