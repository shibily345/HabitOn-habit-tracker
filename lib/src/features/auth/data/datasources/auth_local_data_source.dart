import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_on_assig/config/errors/exceptions.dart';
import 'package:habit_on_assig/src/features/auth/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuth({required UserModel? authToCache});
  Future<String> getLastAuth();
}

const cachedAuth = 'auth';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String> getLastAuth() {
    final auth = sharedPreferences.getString(cachedAuth);

    if (auth != null) {
      return Future.value(auth);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheAuth({required UserModel? authToCache}) async {
    if (authToCache != null) {
      var data = json.encode(
        authToCache,
      );
      sharedPreferences.setString(
        cachedAuth,
        json.encode(
          authToCache.toJson(),
        ),
      );
      print("------------- $authToCache-------------$data");
    } else {
      throw CacheException();
    }
  }
}
