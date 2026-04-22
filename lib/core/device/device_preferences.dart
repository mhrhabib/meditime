import 'package:shared_preferences/shared_preferences.dart';

class DevicePreferences {
  static const _keyDefaultProfile = 'default_profile_id';
  static const _keyWatchedProfiles = 'watched_profile_ids';

  static Future<String?> getDefaultProfileId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyDefaultProfile);
  }

  static Future<void> setDefaultProfileId(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_keyDefaultProfile);
    } else {
      await prefs.setString(_keyDefaultProfile, id);
    }
  }

  static Future<List<String>> getWatchedProfileIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyWatchedProfiles);
    return raw ?? <String>[];
  }

  static Future<void> setWatchedProfileIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyWatchedProfiles, ids);
  }

  static Future<void> addWatchedProfileId(String id) async {
    final list = await getWatchedProfileIds();
    if (!list.contains(id)) {
      list.add(id);
      await setWatchedProfileIds(list);
    }
  }

  static Future<void> removeWatchedProfileId(String id) async {
    final list = await getWatchedProfileIds();
    if (list.remove(id)) await setWatchedProfileIds(list);
  }
}
