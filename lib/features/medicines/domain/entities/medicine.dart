import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final String id;
  final String name;
  final String type;
  final String schedule;
  final int stockRemaining;
  final int stockTotal;
  final int daysLeft;
  final bool isLowStock;

  const Medicine({
    required this.id,
    required this.name,
    required this.type,
    required this.schedule,
    required this.stockRemaining,
    required this.stockTotal,
    required this.daysLeft,
    required this.isLowStock,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        schedule,
        stockRemaining,
        stockTotal,
        daysLeft,
        isLowStock,
      ];
}
