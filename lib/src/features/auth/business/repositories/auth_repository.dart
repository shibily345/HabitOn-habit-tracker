import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/src/features/auth/business/entities/auth_entity.dart';
import 'package:habit_on_assig/src/features/auth/data/models/auth_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> googleSignIn();
  Future<Either<Failure, UserModel>> appleSignIn();
}
