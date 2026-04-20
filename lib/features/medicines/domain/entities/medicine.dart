import 'package:equatable/equatable.dart';

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

  const Medicine({
    required this.id,
    this.profileId = 'me', // Default for legacy/main user
    required this.name,
    required this.type,
    required this.schedule,
    required this.stockRemaining,
    required this.stockTotal,
    required this.daysLeft,
    required this.isLowStock,
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
      ];
}
