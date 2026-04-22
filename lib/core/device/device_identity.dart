import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Generates a stable UUID for this device on first run and persists it.
/// All local writes stamp this ID so cross-device conflict resolution
/// can break same-timestamp ties deterministically.
class DeviceIdentity {
  static const _key = 'device_id';
  static String? _cached;

  static Future<String> get id async {
    if (_cached != null) return _cached!;
    final prefs = await SharedPreferences.getInstance();
    var stored = prefs.getString(_key);
    if (stored == null) {
      stored = const Uuid().v4();
      await prefs.setString(_key, stored);
    }
    _cached = stored;
    return stored;
  }

  /// Returns the cached ID synchronously once [id] has been awaited at least once.
  static String get cachedId => _cached ?? 'unknown';
}
