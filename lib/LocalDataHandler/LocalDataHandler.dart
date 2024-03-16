import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/User.dart';

class LocalDataHandler {
  static saveUserData(Map<String, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user));
  }

  static Future<User?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      var userMap = jsonDecode(user);
      return User.fromJson(userMap);
    }
    return null;
  }

  static removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}
