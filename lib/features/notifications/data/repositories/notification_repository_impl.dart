import '../../../../core/storage/app_database.dart';
import '../../../../core/storage/data_mappers.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final AppDatabase _db;

  NotificationRepositoryImpl({AppDatabase? db}) : _db = db ?? AppDatabase.instance;

  static final NotificationRepositoryImpl instance = NotificationRepositoryImpl();

  @override
  Stream<List<NotificationItem>> watchAll() =>
      _db.watchAllNotifications().map((rows) => rows.map(DataMappers.notificationFromTable).toList());

  @override
  Future<List<NotificationItem>> getAll() async {
    final rows = await _db.getAllNotifications();
    return rows.map(DataMappers.notificationFromTable).toList();
  }

  @override
  Future<void> add(NotificationItem notification) async {
    await _db.insertNotification(DataMappers.notificationToTable(notification));
  }

  @override
  Future<void> markRead(String id) async {
    await _db.markNotificationRead(id);
  }

  @override
  Future<void> markAllRead() async {
    await _db.markAllNotificationsRead();
  }

  @override
  Future<void> clearAll() async {
    await _db.clearNotifications();
  }
}
