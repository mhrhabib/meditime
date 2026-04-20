import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/notifications/notification_service.dart';
import 'package:meditime/core/services/report_service.dart';
import 'package:meditime/features/emergency_card/data/repositories/emergency_card_repository_impl.dart';
import 'package:meditime/features/emergency_card/domain/entities/emergencycard.dart';
import 'package:meditime/features/emergency_card/domain/repositories/emergency_card_repository.dart';

class EmergencyCardState {
  final EmergencyCard? card;
  final bool isPersistentNotificationEnabled;

  const EmergencyCardState({
    this.card,
    this.isPersistentNotificationEnabled = false,
  });

  EmergencyCardState copyWith({
    EmergencyCard? card,
    bool? isPersistentNotificationEnabled,
  }) {
    return EmergencyCardState(
      card: card ?? this.card,
      isPersistentNotificationEnabled:
          isPersistentNotificationEnabled ?? this.isPersistentNotificationEnabled,
    );
  }
}

class EmergencyCardCubit extends Cubit<EmergencyCardState> {
  final EmergencyCardRepository _repo;

  EmergencyCardCubit({EmergencyCardRepository? repo})
      : _repo = repo ?? EmergencyCardRepositoryImpl.instance,
        super(const EmergencyCardState()) {
    _loadCard();
  }

  Future<void> _loadCard() async {
    final card = await _repo.get();
    if (card != null) {
      emit(state.copyWith(card: card));
      if (state.isPersistentNotificationEnabled) {
        updatePersistentNotification(true);
      }
    }
  }

  Future<void> saveCard(EmergencyCard card) async {
    await _repo.save(card);
    emit(state.copyWith(card: card));

    if (state.isPersistentNotificationEnabled) {
      updatePersistentNotification(true);
    }
  }

  Future<void> updatePersistentNotification(bool enabled) async {
    emit(state.copyWith(isPersistentNotificationEnabled: enabled));

    if (enabled && state.card != null) {
      await NotificationService.instance.showEmergencyCard(
        name: state.card!.fullName,
        bloodType: state.card!.bloodType,
        emergencyContact:
            '${state.card!.emergencyContactName} (${state.card!.emergencyContactPhone})',
      );
    } else {
      await NotificationService.instance.cancel(888);
    }
  }

  Future<void> exportPdf() async {
    final card = state.card;
    if (card == null) return;

    await ReportService.generateEmergencyCardPdf(
      name: card.fullName,
      bloodType: card.bloodType,
      allergies: card.allergies,
      conditions: card.conditions,
      emergencyContact:
          '${card.emergencyContactName} (${card.emergencyContactPhone})',
    );
  }
}
