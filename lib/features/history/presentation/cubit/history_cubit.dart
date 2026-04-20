import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/services/report_service.dart';
import 'package:meditime/features/history/data/repositories/history_repository_impl.dart';
import 'package:meditime/features/history/domain/entities/dose_log.dart';
import 'package:meditime/features/history/domain/repositories/history_repository.dart';

enum HistoryFilter { month, all }

class HistoryState {
  final List<DoseLog> events;
  final double adherenceRate;
  final int takenCount;
  final int missedCount;
  final Map<String, double> perMedicineAdherence; // medicine name -> rate
  final HistoryFilter filter;

  const HistoryState({
    this.events = const [],
    this.adherenceRate = 0.0,
    this.takenCount = 0,
    this.missedCount = 0,
    this.perMedicineAdherence = const {},
    this.filter = HistoryFilter.month,
  });

  HistoryState copyWith({
    List<DoseLog>? events,
    double? adherenceRate,
    int? takenCount,
    int? missedCount,
    Map<String, double>? perMedicineAdherence,
    HistoryFilter? filter,
  }) {
    return HistoryState(
      events: events ?? this.events,
      adherenceRate: adherenceRate ?? this.adherenceRate,
      takenCount: takenCount ?? this.takenCount,
      missedCount: missedCount ?? this.missedCount,
      perMedicineAdherence: perMedicineAdherence ?? this.perMedicineAdherence,
      filter: filter ?? this.filter,
    );
  }
}

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository _repo;
  StreamSubscription? _sub;

  HistoryCubit({HistoryRepository? repo})
      : _repo = repo ?? HistoryRepositoryImpl.instance,
        super(const HistoryState()) {
    _sub = _repo.watchAll().listen(_recompute);
  }

  void setFilter(HistoryFilter filter) async {
    emit(state.copyWith(filter: filter));
    final all = await _repo.getAll();
    _recompute(all);
  }

  void _recompute(List<DoseLog> allLogs) {
    var logs = allLogs;
    if (state.filter == HistoryFilter.month) {
      final now = DateTime.now();
      logs = logs
          .where((e) =>
              e.dateTime.month == now.month && e.dateTime.year == now.year)
          .toList();
    }

    int taken = 0;
    int missed = 0;
    final Map<String, List<bool>> medStats = {};

    for (final event in logs) {
      if (event.status == DoseStatus.taken) {
        taken++;
        medStats.putIfAbsent(event.medicineName, () => []).add(true);
      } else if (event.status == DoseStatus.skipped) {
        missed++;
        medStats.putIfAbsent(event.medicineName, () => []).add(false);
      }
    }

    final totalActionable = taken + missed;
    final overallAdherence =
        totalActionable > 0 ? (taken / totalActionable) : 1.0;

    final Map<String, double> perMed = {};
    medStats.forEach((name, results) {
      final t = results.where((r) => r).length;
      perMed[name] = t / results.length;
    });

    emit(state.copyWith(
      events: logs,
      adherenceRate: overallAdherence,
      takenCount: taken,
      missedCount: missed,
      perMedicineAdherence: perMed,
    ));
  }

  Future<void> exportPdfReport(String userName) async {
    final medicineNames = <String, String>{
      for (final event in state.events) event.medicineId: event.medicineName,
    };

    await ReportService.generateHistoryReport(
      userName: userName,
      events: state.events,
      medicineNames: medicineNames,
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
