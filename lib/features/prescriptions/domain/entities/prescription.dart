import 'package:equatable/equatable.dart';

class Prescription extends Equatable {
  final String id;
  final String doctorName;
  final DateTime date;
  final String reason;
  final String? imageUrl;
  final List<String> medicines;
  final bool isScanned;

  const Prescription({
    required this.id,
    required this.doctorName,
    required this.date,
    required this.reason,
    this.imageUrl,
    this.medicines = const [],
    this.isScanned = false,
  });

  @override
  List<Object?> get props => [id, doctorName, date, reason, imageUrl, medicines, isScanned];
}
