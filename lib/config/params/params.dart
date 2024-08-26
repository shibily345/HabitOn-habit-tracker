import 'package:habit_on_assig/src/features/habits/data/model/habit_model.dart';

class NoParams {}

class TemplateParams {}

class HabitParams {
  final String id;

  HabitParams({required this.id});
}

class AddHabitParams {
  final HabitModel habit;
  final String id;

  AddHabitParams(this.id, {required this.habit});
}

class PokemonParams {
  final String id;
  const PokemonParams({
    required this.id,
  });
}
