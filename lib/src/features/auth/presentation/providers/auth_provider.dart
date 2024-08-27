import 'package:dartz/dartz.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/connection/network_info.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/src/features/auth/business/usecases/apple_sign_in.dart';
import 'package:habit_on_assig/src/features/auth/business/usecases/google_sign_in.dart';
import 'package:habit_on_assig/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:habit_on_assig/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:habit_on_assig/src/features/auth/data/models/auth_model.dart';
import 'package:habit_on_assig/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  UserModel? auth;
  Failure? failure;
  AuthenticationProvider({
    this.auth,
    this.failure,
  });
  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  Future<Either<Failure, UserModel>> eitherFailureOrAuth() async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAuth = await GoogleSignIN(authRepository: repository).call();

    failureOrAuth.fold(
      (Failure newFailure) {
        auth = null;
        failure = newFailure;
        notifyListeners();
      },
      (UserModel newAuth) {
        auth = newAuth;
        failure = null;
        notifyListeners();
      },
    );
    return failureOrAuth;
  }

  Future<Either<Failure, UserModel>> eitherFailureOrAuthWithApple() async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAuth = await AppleSignIn(authRepository: repository).call();

    failureOrAuth.fold(
      (Failure newFailure) {
        auth = null;
        failure = newFailure;
        notifyListeners();
      },
      (UserModel newAuth) {
        auth = newAuth;
        failure = null;
        notifyListeners();
      },
    );
    return failureOrAuth;
  }

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'en';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode? get themeMode => _themeMode;

  void toggleTheme(ThemeMode theme) {
    _themeMode = theme;
    notifyListeners();
  }
}
