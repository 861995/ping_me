import 'package:firebase_auth/firebase_auth.dart';

abstract class UserLocalRepository {
  Future<void> saveUser(User user, String fcmToken);
  Map<String, dynamic>? getUser();
  Future<void> deleteUser();
}
