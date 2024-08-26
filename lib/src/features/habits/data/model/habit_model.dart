import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';

class HabitModel extends HabitEntity {
  const HabitModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.color,
    required super.days,
    required super.repeatMode,
    required super.timer,
    required super.doneDates,
    required super.missedDates,
    required super.goal,
    required super.streak,
    required super.reminders,
    required super.repeatPerDay,
    required super.endDate,
    required super.endByDays,
    required super.trackingData,
    required super.category,
    required super.isPaused,
    required super.createdAt,
    required super.updatedAt,
    required super.hasEnd,
    required super.description,
  });

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      color: map['color'] ?? '',
      days: List<String>.from(map['days'] ?? []),
      repeatMode: map['repeatMode'] ?? '',
      timer: map['timer'] ?? 0,
      doneDates: (map['doneDates'] as List<dynamic>?)?.map((date) {
            if (date is String) {
              return DateTime.tryParse(date) ?? DateTime.now();
            } else if (date is Timestamp) {
              return date.toDate();
            } else {
              return DateTime.now();
            }
          }).toList() ??
          [],
      missedDates: (map['missedDates'] as List<dynamic>?)
              ?.map(
                  (date) => DateTime.tryParse(date as String) ?? DateTime.now())
              .toList() ??
          [],
      goal: map['goal'] ?? '',
      streak: map['streak'] ?? 0,
      reminders: List<String>.from(map['reminders'] ?? []),
      repeatPerDay: map['repeatPerDay'] ?? 0,
      endDate: DateTime.tryParse(
              map['endDate'] ?? DateTime.now().toIso8601String()) ??
          DateTime.now(),
      endByDays: map['endByDays'] ?? 0,
      trackingData: List<String>.from(map['trackingData'] ?? []),
      category: map['category'] ?? '',
      isPaused: map['isPaused'] ?? false,
      createdAt: DateTime.tryParse(
              map['createdAt'] ?? DateTime.now().toIso8601String()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(
              map['updatedAt'] ?? DateTime.now().toIso8601String()) ??
          DateTime.now(),
      hasEnd: map['hasEnd'] ?? false,
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'days': days,
      'repeatMode': repeatMode,
      'timer': timer,
      'doneDates': doneDates.map((date) => date.toIso8601String()).toList(),
      'missedDates': missedDates.map((date) => date.toIso8601String()).toList(),
      'goal': goal,
      'streak': streak,
      'reminders': reminders,
      'repeatPerDay': repeatPerDay,
      'endDate': endDate.toIso8601String(),
      'endByDays': endByDays,
      'trackingData': trackingData,
      'category': category,
      'isPaused': isPaused,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'hasEnd': hasEnd,
      'description': description,
    };
  }

  static List<HabitModel> listFromMap(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => HabitModel.fromMap(json)).toList();
  }

  static List<Map<String, dynamic>> listToMap(List<HabitModel> habits) {
    return habits.map((habit) => habit.toMap()).toList();
  }

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      HabitModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();

  static List<HabitModel> listFromJson(List<Map<String, dynamic>> jsonList) =>
      listFromMap(jsonList);

  static List<Map<String, dynamic>> listToJson(List<HabitModel> habits) =>
      listToMap(habits);
}
