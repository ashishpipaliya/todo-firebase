import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    isUserLoggedIn();
  }

  User? user;

  void isUserLoggedIn() {
    user = AuthService.instance.user;
    debugPrint(jsonEncode(user));
    notifyListeners();
  }

  // on auth change
  Stream<User?> get userLoginState => AuthService.instance.userLoginState;
}
