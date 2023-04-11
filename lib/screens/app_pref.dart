class AppPreferences {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String getString(String key, [String defaultValue = '']) {
    return _preferences.getString(key) ?? defaultValue;
  }

  static Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  static int getInt(String key, [int defaultValue = 0]) {
    return _preferences.getInt(key) ?? defaultValue;
  }

  static Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  static double getDouble(String key, [double defaultValue = 0.0]) {
    return _preferences.getDouble(key) ?? defaultValue;
  }

  static Future<bool> setDouble(String key, double value) {
    return _preferences.setDouble(key, value);
  }

  static bool getBool(String key, [bool defaultValue = false]) {
    return _preferences.getBool(key) ?? defaultValue;
  }

  static Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  static Set<String> getStringList(String key, [Set<String> defaultValues = const {}]) {
    return _preferences.getStringList(key)?.toSet() ?? defaultValues;
  }

  static Future<bool> setStringList(String key, List<String> values) {
    return _preferences.setStringList(key, values);
  }

  static Future<bool> remove(String key) {
    return _preferences.remove(key);
  }

  static Future<bool> clear() {
    return _preferences.clear();
  }
}