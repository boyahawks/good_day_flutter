import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? prefs;

  void saveToDisk({required String key, required dynamic value}) {
    if (value.runtimeType == String) {
      prefs?.setString(key, value);
    } else if (value.runtimeType == int) {
      prefs?.setInt(key, value);
    } else if (value.runtimeType == bool) {
      prefs?.setBool(key, value);
    } else if (value.runtimeType == List) {
      prefs?.setStringList(key, value);
    }
  }

  dynamic getFromDisk({required String key}) {
    var value = prefs?.get(key);
    return value;
  }
}
