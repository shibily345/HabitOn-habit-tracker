import 'dart:convert';
import 'package:flutter/services.dart';

class Habit {
  final String name;
  final String image;
  final List<String> days;
  final String timeToComplete;

  Habit({
    required this.name,
    required this.image,
    required this.days,
    required this.timeToComplete,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      name: json['name'],
      image: json['image'],
      days: List<String>.from(json['days']),
      timeToComplete: json['time_to_complete'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'days': days,
      'time_to_complete': timeToComplete,
    };
  }
}

class HabitData {
  final List<Habit> habits;

  HabitData({required this.habits});

  factory HabitData.fromJson(Map<String, dynamic> json) {
    var list = json['habits'] as List;
    List<Habit> habitList = list.map((i) => Habit.fromJson(i)).toList();

    return HabitData(habits: habitList);
  }

  Map<String, dynamic> toJson() {
    return {
      'habits': habits.map((habit) => habit.toJson()).toList(),
    };
  }
}

Future<HabitData> loadHabitData() async {
  final String response =
      await rootBundle.loadString('assets/data/default_habits.json');
  final data = await json.decode(response);
  return HabitData.fromJson(data);
}
