import 'package:dartz/dartz.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/config/params/params.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';
import 'package:habit_on_assig/src/features/habits/data/model/habit_model.dart';

import '../repositories/habits_repository.dart';

class AddHabit {
  final HabitRepository repository;

  AddHabit(this.repository);

  Future<Either<Failure, String>> call({required AddHabitParams params}) async {
    return await repository.addHabit(params: params);
  }
}
