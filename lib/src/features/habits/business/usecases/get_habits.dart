import 'package:dartz/dartz.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/config/params/params.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';

import '../repositories/habits_repository.dart';

class GetHabit {
  final HabitRepository repository;

  GetHabit(this.repository);

  Future<Either<Failure, List<HabitEntity>>> call(
      {required HabitParams params}) async {
    return await repository.getHabits(params: params);
  }
}
