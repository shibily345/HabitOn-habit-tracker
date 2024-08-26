import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/connection/network_info.dart';
import 'package:habit_on_assig/config/errors/failure.dart';
import 'package:habit_on_assig/config/params/params.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';
import 'package:habit_on_assig/src/features/habits/business/usecases/add_habits.dart';
import 'package:habit_on_assig/src/features/habits/business/usecases/get_habits.dart';
import 'package:habit_on_assig/src/features/habits/data/datasources/habits_local_data_source.dart';
import 'package:habit_on_assig/src/features/habits/data/datasources/habits_remote_data_source.dart';
import 'package:habit_on_assig/src/features/habits/data/repositories/habit_repository_impl.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitEntity>? habit;
  Failure? failure;
  String? sort = "nct";
  HabitProvider({
    this.habit,
    this.failure,
  });
  String? get sortValue => sort;
  // List<HabitEntity>? get habitList => habit;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Either<Failure, List<HabitEntity>>> eitherFailureOrHabit({
    required HabitParams value,
  }) async {
    HabitRepositoryImpl repository = HabitRepositoryImpl(
      remoteDataSource: HabitRemoteDataSourceImpl(),
      localDataSource: HabitLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrHabit = await GetHabit(repository).call(
      params: HabitParams(id: value.id),
    );

    failureOrHabit.fold(
      (newFailure) {
        habit = null;
        failure = newFailure;
        notifyListeners();
      },
      (newHabit) {
        habit = newHabit;
        failure = null;
        notifyListeners();
      },
    );
    return failureOrHabit;
  }

  Future<String> eitherFailureOrAddHabit({
    required AddHabitParams value,
  }) async {
    String id = "";
    HabitRepositoryImpl repository = HabitRepositoryImpl(
      remoteDataSource: HabitRemoteDataSourceImpl(),
      localDataSource: HabitLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrAddHabit = await AddHabit(repository).call(
      params: AddHabitParams(
        value.id,
        habit: value.habit,
      ),
    );

    failureOrAddHabit.fold(
      (newFailure) {
        habit = null;
        failure = newFailure;
        notifyListeners();
      },
      (habitId) {
        failure = null;
        notifyListeners();
        print("_________________$habitId");
        id = habitId;
      },
    );
    print("$id------------------------------");
    return id;
  }

  void updateSort(String value) {
    sort = value;
    notifyListeners();
  }

  Future<void> scheduleReminderNotification(
      TimeOfDay time, HabitEntity habit) async {
    DateTime now = DateTime.now();
    DateTime scheduledTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    String weekday = DateFormat('EEE').format(now);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    if (habit.days.contains(weekday)) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: habit.name,
          body: 'This is the time for ${habit.name}',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(
          date: scheduledTime,
          repeats: true,
          preciseAlarm: true,
        ),
      );
      print("Success fully scheduled");
    } else {
      print("....................not contain week day $weekday");
    }
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    RegExp regExp = RegExp(r"TimeOfDay\((\d{2}):(\d{2})\)");
    Match? match = regExp.firstMatch(timeString);

    if (match == null) {
      throw const FormatException(
          'Invalid time format. Expected TimeOfDay(HH:mm)');
    }

    int hour = int.parse(match.group(1)!);
    int minute = int.parse(match.group(2)!);

    return TimeOfDay(hour: hour, minute: minute);
  }

  List<TimeOfDay> convertStringsToTimeOfDay(List<String> timeStrings) {
    return timeStrings
        .map((timeString) => stringToTimeOfDay(timeString))
        .toList();
  }

  void scheduleAllRemindersForHabit(HabitEntity habit) {
    List<TimeOfDay> timeOfDayList = convertStringsToTimeOfDay(habit.reminders);
    for (TimeOfDay time in timeOfDayList) {
      scheduleReminderNotification(time, habit);
      print("======================set for $time");
    }
  }

  Future<void> updateHabitField({
    required String habitId,
    required String userId,
    required String fieldName,
    required dynamic newValue,
  }) async {
    try {
      _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .update({
        fieldName: newValue,
      });
      print('Success updating $fieldName $newValue');
      notifyListeners();
    } catch (e) {
      print('Error updating habit field: $e');
    }
  }

  Future<void> updateHabit({
    required String userId,
    required String habitId,
    required Map<String, dynamic> updates,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitId);

    try {
      await docRef.update(updates);
    } catch (e) {
      print('Error updating habit: $e');
    }
  }

  Future<void> deleteHabit({
    required String userId,
    required String habitId,
  }) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitId);

    try {
      await docRef.delete();
    } catch (e) {
      print('Error updating habit: $e');
    }
  }

  int calculateTotalTimes({
    required DateTime createdDate,
    required DateTime endDate,
    required int repeatPerDay,
    required List<String> weekdays,
  }) {
    // Mapping of weekdays to DateTime weekday numbers
    Map<String, int> weekdayMap = {
      "Mon": DateTime.monday,
      "Tue": DateTime.tuesday,
      "Wed": DateTime.wednesday,
      "Thu": DateTime.thursday,
      "Fri": DateTime.friday,
      "Sat": DateTime.saturday,
      "Sun": DateTime.sunday,
    };

    // Convert the list of weekdays to a list of DateTime weekday numbers
    List<int> targetWeekdays = weekdays.map((day) => weekdayMap[day]!).toList();

    int totalTimes = 0;

    // Loop from the createdDate to the endDate
    for (DateTime date = createdDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      // If the current day is one of the target weekdays
      if (targetWeekdays.contains(date.weekday)) {
        totalTimes += repeatPerDay;
      }
    }

    return totalTimes;
  }

  TimeOfDay _getClosestReminder(List<TimeOfDay> reminders) {
    // Get the current time
    final now = TimeOfDay.now();

    // Sort the reminders by time and find the first one after 'now'
    reminders.sort((a, b) => a.hour.compareTo(b.hour) != 0
        ? a.hour.compareTo(b.hour)
        : a.minute.compareTo(b.minute));

    return reminders.firstWhere(
        (reminder) =>
            reminder.hour > now.hour ||
            (reminder.hour == now.hour && reminder.minute > now.minute),
        orElse: () => reminders
            .first); // Default to the earliest reminder if all have passed today
  }

  void sortHabitsByClosestReminder(List<HabitEntity> habits) {
    habits.sort((a, b) {
      final closestA =
          _getClosestReminder(convertStringsToTimeOfDay(a.reminders));
      final closestB =
          _getClosestReminder(convertStringsToTimeOfDay(b.reminders));

      if (closestA.hour != closestB.hour) {
        return closestA.hour.compareTo(closestB.hour);
      } else {
        return closestA.minute.compareTo(closestB.minute);
      }
    });
  }

  List<HabitEntity> filterHabitsByGroup(
    List<HabitEntity> habits,
    String group,
  ) {
    DateTime today = DateTime.now();
    //String todayWeekday = today.weekday.toString();
    String todayWeekday = DateFormat('EEE').format(today);
    // Convert today's weekday to string
    print("$todayWeekday  ====465092389893403498038476509875628035620984");
    switch (group) {
      case 'ct': // Completed Today
        return habits.where((habit) {
          // Exclude habits that are not scheduled for today
          if (!habit.days.contains(todayWeekday)) return false;

          int completedToday = habit.doneDates
              .where((date) =>
                  date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day)
              .length;
          return completedToday >= habit.repeatPerDay;
        }).toList();

      case 'nct': // Not Completed Today
        return habits.where((habit) {
          // Exclude habits that are not scheduled for today
          if (!habit.days.contains(todayWeekday)) return false;

          int completedToday = habit.doneDates
              .where((date) =>
                  date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day)
              .length;
          return completedToday < habit.repeatPerDay;
        }).toList();

      case 'nt': // Not Today
        return habits.where((habit) {
          return !habit.days.contains(todayWeekday);
        }).toList();

      case 'all': // All Habits
      default:
        return habits;
    }
  }
}
