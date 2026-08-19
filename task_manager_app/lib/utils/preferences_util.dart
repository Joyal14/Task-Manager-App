import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil {
  static PreferencesUtil? _preferenceUtil;
  static SharedPreferences? _preferences;

  static Future getInstance() async {
    if (_preferenceUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = PreferencesUtil._();
      await secureStorage._init();
      _preferenceUtil = secureStorage;
    }
    return _preferenceUtil;
  }

  PreferencesUtil._();

  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static bool checkPreference(String key) {
    return _preferences!.containsKey(key);
  }

  
  static String? getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences!.getString(key);
  }

 
  static Future<bool>? setString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences!.setString(key, value);
  }


  static int? getInt(String key, {int defValue = 0}) {
    if (_preferences == null) return defValue;
    return _preferences!.getInt(key);
  }


  static Future<bool>? setInt(String key, int value) {
    if (_preferences == null) return null;
    return _preferences!.setInt(key, value);
  }

 
  static getObject(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return json.decode(_preferences?.getString(key) ?? '');
  }

 
  static Future<bool>? setObject(String key, value) {
    if (_preferences == null) return null;
    return _preferences!.setString(key, json.encode(value));
  }


  static Future<bool>? remove(String key) {
    if (_preferences == null) return null;
    return _preferences!.remove(key);
  }

 
  static bool? getBool(String key, {bool defValue = false}) {
    if (_preferences == null) return defValue;
    return _preferences!.getBool(key);
  }
 
  static Future<bool>? setBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences!.setBool(key, value);
  }


  static Future? clear() {
    if (_preferences == null) return null;
    return _preferences!.clear();
  }

  static void clearPreferenceData() {}

  static void removeDataFromSF() {}

  static void addAuthDatatoSF() {}
}
