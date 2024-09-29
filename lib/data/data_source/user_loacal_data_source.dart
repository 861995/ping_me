import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserLocalDataSource {
  final SharedPreferences _sharedPreferences;

  UserLocalDataSource(this._sharedPreferences);

  Future<void> saveUser(User user, String fcmToken) async {
    final userMap = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      "fcmToken": fcmToken,
    };

    final jsonString = jsonEncode(userMap);
    await _sharedPreferences.setString('user', jsonString);
  }

  Map<String, dynamic>? getUser() {
    try {
      final jsonString = _sharedPreferences.getString('user');
      if (jsonString != null) {
        final Map<String, dynamic> userMap = jsonDecode(jsonString);
        return userMap;
      } else {
        if (kDebugMode) {
          print('No user found in SharedPreferences');
        }
        return null;
      }
    } catch (e) {
      print('Error retrieving user from SharedPreferences: $e');
      return null;
    }
  }

  Future<void> deleteUser() async {
    await _sharedPreferences.remove('user');
  }
}
