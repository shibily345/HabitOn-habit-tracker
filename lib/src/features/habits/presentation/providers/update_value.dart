import 'package:flutter/material.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/model/update_model.dart';

class HUProvider with ChangeNotifier {
  HabitUpdateModel habitData;

  HUProvider({
    required this.habitData,
  });

  void updateName(String name) {
    habitData.name = name;
    notifyListeners();
  }

  void updateIcon(String icon) {
    habitData.icon = icon;
    notifyListeners();
  }

  void updateColor(String color) {
    habitData.color = color;
    notifyListeners();
  }

  void updateDays(String days) {
    habitData.days.add(days);
    notifyListeners();
  }

  void updateallDays(List<String> days) {
    habitData.days = days;
    notifyListeners();
  }

  void deleteDays(String days) {
    habitData.days.remove(days);
    notifyListeners();
  }

  void updateRepeatMode(String repeatMode) {
    habitData.repeatMode = repeatMode;
    notifyListeners();
  }

  void updateTimer(int timer) {
    habitData.timer = timer;
    notifyListeners();
  }

  void updateDoneDates(List<DateTime> doneDates) {
    habitData.doneDates = doneDates;
    notifyListeners();
  }

  void updateMissedDates(List<DateTime> missedDates) {
    habitData.missedDates = missedDates;
    notifyListeners();
  }

  void updateGoal(String goal) {
    habitData.goal = goal;
    notifyListeners();
  }

  void updateStreak(int streak) {
    habitData.streak = streak;
    notifyListeners();
  }

  void updateReminders(String reminders) {
    habitData.reminders.add(reminders);
    notifyListeners();
  }

  void updateAllReminders(List<String> reminders) {
    habitData.reminders = reminders;
    notifyListeners();
  }

  void deleteReminders(String time) {
    habitData.reminders.remove(time);
    notifyListeners();
  }

  void updateRepeatPerDay(int repeatPerDay) {
    habitData.repeatPerDay = repeatPerDay;
    notifyListeners();
  }

  void updateEndDate(DateTime endDate) {
    habitData.endDate = endDate;
    notifyListeners();
  }

  void updateEndByDays(int endByDays) {
    habitData.endByDays = endByDays;
    notifyListeners();
  }

  void updateTrackingData(List<String> trackingData) {
    habitData.trackingData = trackingData;
    notifyListeners();
  }

  void updateCategory(String category) {
    habitData.category = category;
    notifyListeners();
  }

  void updateIsPaused(bool isPaused) {
    habitData.isPaused = isPaused;
    notifyListeners();
  }

  void updateCreatedAt(DateTime createdAt) {
    habitData.createdAt = createdAt;
    notifyListeners();
  }

  void updateUpdatedAt(DateTime updatedAt) {
    habitData.updatedAt = updatedAt;
    notifyListeners();
  }

  void updateHasEnd(bool hasEnd) {
    habitData.hasEnd = hasEnd;
    notifyListeners();
  }

  void updateDescription(String description) {
    habitData.description = description;
    notifyListeners();
  }

  void clearAll() {
    habitData = HabitUpdateModel(
      id: "",
      name: "",
      icon: "",
      color: const Color.fromARGB(255, 252, 235, 233).toString(),
      days: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      repeatMode: "",
      timer: 0,
      doneDates: [],
      missedDates: [],
      goal: "",
      streak: 0,
      reminders: [
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute + 2)
            .toString()
      ],
      repeatPerDay: 1,
      endDate: DateTime.utc(2030),
      endByDays: 0,
      trackingData: [],
      category: "New Habit",
      isPaused: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      hasEnd: false,
      description: "",
    );
    print("Cleared All");
    notifyListeners();
  }
}
