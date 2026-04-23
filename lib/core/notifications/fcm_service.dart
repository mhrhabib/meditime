import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:meditime/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:meditime/features/notifications/domain/entities/notification_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FcmService] Handling background message: ${message.messageId}');
  
  await NotificationRepositoryImpl.instance.add(NotificationItem(
    id: const Uuid().v4(),
    title: message.notification?.title ?? 'Notification',
    body: message.notification?.body ?? '',
    timestamp: DateTime.now(),
    type: 'general',
    isRead: false,
    payload: message.data.toString(),
  ));
}

class FcmService {
  FcmService._();
  static final instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('[FcmService] User granted permission: ${settings.authorizationStatus}');

      final token = await _messaging.getToken();
      debugPrint('[FcmService] FCM token: $token');
      if (token != null) {
        await saveTokenToSupabase(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        saveTokenToSupabase(newToken);
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        debugPrint('[FcmService] Handling foreground message: ${message.messageId}');
        
        await NotificationRepositoryImpl.instance.add(NotificationItem(
          id: const Uuid().v4(),
          title: message.notification?.title ?? 'Notification',
          body: message.notification?.body ?? '',
          timestamp: DateTime.now(),
          type: 'general',
          isRead: false,
          payload: message.data.toString(),
        ));
      });

      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageAction(initialMessage);
      }

      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageAction);

    } catch (e) {
      debugPrint('[FcmService] init error: $e');
    }
  }

  Future<void> saveTokenToSupabase(String token) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        debugPrint('[FcmService] No user logged in, skipping token save');
        return;
      }

      await Supabase.instance.client.from('fcm_tokens').upsert({
        'user_id': user.id,
        'token': token,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id, token');
      
      debugPrint('[FcmService] Token saved to Supabase');
    } catch (e) {
      debugPrint('[FcmService] Error saving token to Supabase: $e');
    }
  }

  void _handleMessageAction(RemoteMessage message) {
    debugPrint('[FcmService] User tapped notification: ${message.messageId}');
  }

  Future<dynamic> notifyCaregiver({
    required String caregiverId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final client = Supabase.instance.client;
    final payload = {
      'user_id': caregiverId,
      'title': title,
      'body': body,
      'data': data ?? {},
    };

    final res = await client.functions.invoke('send-notification', body: payload);
    return res;
  }
}
