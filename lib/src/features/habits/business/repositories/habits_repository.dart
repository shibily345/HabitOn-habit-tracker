import 'package:dartz/dartz.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/config/params/params.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';

abstract class HabitRepository {
  Future<Either<Failure, List<HabitEntity>>> getHabits(
      {required HabitParams params});
  Future<Either<Failure, String>> addHabit({required AddHabitParams params});
}
