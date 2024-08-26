import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/src/features/auth/business/entities/auth_entity.dart';
import 'package:habit_on_assig/src/features/auth/business/repositories/auth_repository.dart';
import 'package:habit_on_assig/src/features/auth/data/models/auth_model.dart';


class AppleSignIn {
  final AuthRepository authRepository;

  AppleSignIn({required this.authRepository});

  Future<Either<Failure, UserModel>> call() async {
    return await authRepository.appleSignIn();
  }
}