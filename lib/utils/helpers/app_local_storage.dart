import 'package:shared_preferences/shared_preferences.dart';

class AppLocalStorage {

  const AppLocalStorage._();

  static AppLocalStorage get _instance => const AppLocalStorage._();

  factory AppLocalStorage() {
    return _instance;
  }

  static SharedPreferences? _prefs;

  /// Initialises local storage to store key-value
  /// paired data. i.e. Music, Sound on/off status
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// This will be used to save the value of type [T]
  /// in the SharedPreferences, where the type [T] can
  /// be int, String, bool or double. For other types,
  /// the value will be saved as String.
  Future<bool> setValue<T>(String key, T value) async {
    if (T == bool) {
      return await (_prefs?.setBool(key, value as bool) ?? false);
    } else if (T == String) {
      return await (_prefs?.setString(key, value as String) ?? false);
    } else if (T == int) {
      return await (_prefs?.setInt(key, value as int) ?? false);
    } else if (T == double) {
      return await (_prefs?.setDouble(key, value as double) ?? false);
    } else {
      return await (_prefs?.setString(key, value.toString()) ?? false);
    }
  }

  /// This will be used to retrieve the value of type [T]
  /// from the SharedPreferences, where the type [T] can
  /// be int, String, bool or double. For other types,
  /// the value will be returned as String.
  Object getValue<T>(String key) {
    if (T == bool) {
      return (_prefs?.getBool(key) ?? true);
    } else if (T == String) {
      return (_prefs?.getString(key) ?? '');
    } else if (T == int) {
      return (_prefs?.getInt(key) ?? 0);
    } else if (T == double) {
      return (_prefs?.getDouble(key) ?? 0.0);
    } else {
      return (_prefs?.getString(key) ?? '');
    }
  }

  /// This will be used to clear the SharedPreferences.
  Future<bool?> clear() async {
    return await _prefs?.clear();
  }
}
