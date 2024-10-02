import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static Future<void> initCacheHelper() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is String) {
      return await sharedPreferences!.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences!.setInt(key, value);
    } else if (value is bool) {
      return await sharedPreferences!.setBool(key, value);
    } else if (value is double) {
      return await sharedPreferences!.setDouble(key, value);
    } else if (value is List<String>) {
      return await sharedPreferences!.setStringList(key, value);
    }
    return false;
  }

  static bool getbool({required String key}) {
    return sharedPreferences!.getBool(key) ?? false;
  }

  static String getString({required String key}) {
    return sharedPreferences!.getString(key) ?? "";
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences!.remove(key);
  }

  static Future<bool> clearData() async {
    return await sharedPreferences!.clear();
  }
}
