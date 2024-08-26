import 'dart:convert';

import 'package:habit_on_assig/config/errors/exceptions.dart';
import 'package:habit_on_assig/src/features/habits/data/model/habit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class HabitLocalDataSource {
  Future<void>? cacheHabit(List<HabitModel>? pokemonToCache);

  Future<List<HabitModel>> getLastHabit();
}

const cachedHabit = 'CACHED_HABITS';

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final SharedPreferences sharedPreferences;

  HabitLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<HabitModel>> getLastHabit() {
    final jsonString = sharedPreferences.getString(cachedHabit);

    if (jsonString != null) {
      print(jsonString);
      String properOne = jsonEncode(jsonString);
      print("$properOne..........>>>>>>>>>>>>>......>>>>>...>..>>.>.>.>>>>");

      return Future.value(HabitModel.listFromMap(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void>? cacheHabit(List<HabitModel>? habitToCache) async {
    if (habitToCache != null) {
      sharedPreferences.setString(
        cachedHabit,
        HabitModel.listToJson(habitToCache).toString(),
      );
    } else {
      throw CacheException();
    }
  }
}
