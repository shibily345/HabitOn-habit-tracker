import 'package:flutter/material.dart';
import 'package:habit_on_assig/src/features/auth/presentation/pages/onboarding_page.dart';
import 'package:habit_on_assig/src/features/auth/presentation/pages/settings.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/habits/create_habit_page.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/habits/habit_view.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/habits/new_habit.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/habits/update_habit.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/home/home_page.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/model/habits_model.dart';
import 'package:habit_on_assig/src/features/skeleton/skeleton.dart';
import 'package:habit_on_assig/src/features/skeleton/splash_page.dart';
import 'package:habit_on_assig/src/features/skeleton/widgets/bottom_nav_home.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const SplashScreen());
      case '/s':
        return _materialRoute(const SkeletonNav());

      case '/newHabit':
        return _materialRoute(const NewHabitPage());
      case '/home':
        return _materialRoute(const HomePage());
      case '/login':
        return _materialRoute(const OnboardingPage());
      case '/settings':
        return _materialRoute(const SettingsPage());
      case '/createHabit':
        return _materialRoute(CreateHabitPage(
          habitData: settings.arguments as Habit,
        ));
      case '/viewHabit':
        return _materialRoute(HabitView(
          habitEntity: settings.arguments as HabitEntity,
        ));
      case '/updateHabit':
        return _materialRoute(UpdateHabitPage(
          habitData: settings.arguments as HabitEntity,
        ));

      default:
        return _materialRoute(const Skeleton());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
