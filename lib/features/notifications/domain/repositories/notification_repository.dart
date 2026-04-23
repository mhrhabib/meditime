import '../../domain/entities/notification_item.dart';

abstract class NotificationRepository {
  Stream<List<NotificationItem>> watchAll();
  Future<List<NotificationItem>> getAll();
  Future<void> add(NotificationItem notification);
  Future<void> markRead(String id);
  Future<void> markAllRead();
  Future<void> clearAll();
}
