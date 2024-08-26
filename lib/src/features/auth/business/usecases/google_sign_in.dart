import 'package:dartz/dartz.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/src/features/auth/business/repositories/auth_repository.dart';
import 'package:habit_on_assig/src/features/auth/data/models/auth_model.dart';

class GoogleSignIN {
  final AuthRepository authRepository;

  GoogleSignIN({required this.authRepository});

  Future<Either<Failure, UserModel>> call() async {
    return await authRepository.googleSignIn();
  }
}
