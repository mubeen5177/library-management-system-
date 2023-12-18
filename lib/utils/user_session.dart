import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static const _isLoggedInKey = 'isLoggedIn';
  static const _userData = 'currentUserData';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setLoggedIn(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, loggedIn);
  }

  static Future<void> setUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userData, jsonEncode(data));
  }

  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    var a = await prefs.getString(
      _userData,
    );
    print("the user data is $a");

    return a;
  }
}
