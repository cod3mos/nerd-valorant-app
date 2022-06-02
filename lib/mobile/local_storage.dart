import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _localStorage;

  static Future init() async {
    _localStorage = await SharedPreferences.getInstance();
  }

  static Future writeString({required String key, required String data}) async {
    await _localStorage.setString(key, data);
  }

  static Future writeBool({required String key, required bool data}) async {
    await _localStorage.setBool(key, data);
  }

  static String readString(String key) {
    return _localStorage.getString(key) ?? '';
  }

  static bool readBool(String key) {
    return _localStorage.getBool(key) ?? false;
  }
}
