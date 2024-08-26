import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_on_assig/config/connection/network_info.dart';
import 'package:habit_on_assig/config/errors/exceptions.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/src/features/auth/business/repositories/auth_repository.dart';
import 'package:habit_on_assig/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:habit_on_assig/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:habit_on_assig/src/features/auth/data/models/auth_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserModel>> googleSignIn() async {
    try {
      UserCredential remoteAuth = await remoteDataSource.googleSignIn();

      localDataSource.cacheAuth(
          authToCache: UserModel.fromFirebaseUser(remoteAuth.user!));

      return Right(UserModel.fromFirebaseUser(remoteAuth.user!));
    } on ServerException {
      return Left(ServerFailure(errorMessage: 'This is a server exception'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> appleSignIn() async {
    try {
      UserCredential remoteAuth = await remoteDataSource.appleSignIn();

      localDataSource.cacheAuth(
          authToCache: UserModel.fromFirebaseUser(remoteAuth.user!));

      return Right(UserModel.fromFirebaseUser(remoteAuth.user!));
    } on ServerException {
      return Left(ServerFailure(errorMessage: 'This is a server exception'));
    }
  }
}
