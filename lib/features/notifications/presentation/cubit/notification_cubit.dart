import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../data/repositories/notification_repository_impl.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repo;
  StreamSubscription? _subscription;

  NotificationCubit({NotificationRepository? repo})
      : _repo = repo ?? NotificationRepositoryImpl.instance,
        super(NotificationInitial());

  void loadNotifications() {
    emit(NotificationLoading());
    _subscription?.cancel();
    _subscription = _repo.watchAll().listen((notifications) {
      emit(NotificationLoaded(notifications));
    }, onError: (e) {
      emit(NotificationError(e.toString()));
    });
  }

  Future<void> markRead(String id) async {
    await _repo.markRead(id);
  }

  Future<void> markAllRead() async {
    await _repo.markAllRead();
  }

  Future<void> clearAll() async {
    await _repo.clearAll();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
