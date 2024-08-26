import 'package:dartz/dartz.dart';
import 'package:habit_on_assig/config/connection/network_info.dart';
import 'package:habit_on_assig/config/errors/exceptions.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/config/params/params.dart';
import 'package:habit_on_assig/src/features/habits/business/repositories/habits_repository.dart';
import 'package:habit_on_assig/src/features/habits/data/datasources/habits_local_data_source.dart';
import 'package:habit_on_assig/src/features/habits/data/datasources/habits_remote_data_source.dart';
import 'package:habit_on_assig/src/features/habits/data/model/habit_model.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitRemoteDataSource remoteDataSource;

  final HabitLocalDataSource localDataSource;

  final NetworkInfo networkInfo;

  HabitRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<HabitModel>>> getHabits(
      {required HabitParams params}) async {
    if (await networkInfo.isConnected!) {
      print("----------------------------------- Connected to Inter Net");

      try {
        final remoteHabit = await remoteDataSource.getHabit(params: params);

        localDataSource.cacheHabit(remoteHabit);

        return Right(remoteHabit);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      print("----------------------------------- No Inter Net");
      try {
        final localHabit = await localDataSource.getLastHabit();
        return Right(localHabit);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'No local data found'));
      }
    }
  }

  @override
  Future<Either<Failure, String>> addHabit(
      {required AddHabitParams params}) async {
    try {
      final response = await remoteDataSource.addHabit(params: params);
      return Right(response);
    } on ServerException {
      return Left(ServerFailure(errorMessage: 'This is a server exception'));
    }
  }
}
