import 'dart:async';
import 'package:flutter/foundation.dart';
// Note: `firebase_messaging` is optional for this scaffold. We avoid a
// hard dependency here by keeping the runtime type dynamic so the app
// can adopt the package when ready.
import 'package:supabase_flutter/supabase_flutter.dart';

/// Lightweight FCM helper. This file is a scaffold: it initializes
/// `FirebaseMessaging` for receiving notifications and provides a
/// server-side trigger method stub that calls our Supabase Edge Function
/// to deliver caregiver alerts.
class FcmService {
  FcmService._();
  static final instance = FcmService._();

  // Use dynamic to avoid compile failures if `firebase_messaging` is not
  // included in the project yet. If you add the package, you can change
  // this back to `FirebaseMessaging` for stronger typing.
  final dynamic _messaging = null;

  Future<void> init() async {
    try {
      // Request permission on iOS/macOS
      await _messaging.requestPermission();

      // Obtain token and register with backend if needed
      final token = await _messaging.getToken();
      debugPrint('[FcmService] FCM token: $token');

      // Optionally send token to backend (Supabase) via a function
      // or REST endpoint so server-side edge functions can target this device.
    } catch (e) {
      debugPrint('[FcmService] init error: $e');
    }
  }

  /// Call a Supabase Edge Function to notify a caregiver.
  /// The edge function is expected to look up caregiver tokens and send
  /// the notification via FCM server API.
  Future<dynamic> notifyCaregiver({
    required String caregiverId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final client = Supabase.instance.client;
    final payload = {
      'caregiver_id': caregiverId,
      'title': title,
      'body': body,
      'data': data ?? {},
    };

    // Replace `notify_caregiver` with your deployed edge function name/path
    final res = await client.functions.invoke('notify_caregiver', body: payload);
    return res;
  }
}
