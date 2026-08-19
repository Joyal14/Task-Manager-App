import 'package:flutter/material.dart';
import 'package:flutter_base/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String english = 'en';

const String constLanguageCode = 'LanguageCode';
Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(constLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(constLanguageCode) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english, 'US');

    default:
      return const Locale(english, 'US');
  }
}

String? getTranslated(BuildContext context, String key) {
  return AppLocalizations.of(context)?.translate(key);
}
