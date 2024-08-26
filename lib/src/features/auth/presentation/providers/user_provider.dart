import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_on_assig/src/features/auth/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> loadUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _user = UserModel(
          uid: user.uid, email: user.email!, displayName: user.displayName);
      notifyListeners();
    }
  }

  Future<void> clearUser() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }
}
