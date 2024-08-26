import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/params/params.dart';
import 'package:habit_on_assig/src/features/auth/presentation/providers/user_provider.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/habit_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Provider.of<HabitProvider>(context, listen: false)
          .eitherFailureOrHabit(value: HabitParams(id: user.uid))
          .then((ok) {
        Navigator.pushReplacementNamed(
          context,
          '/s',
        );
      });
      Provider.of<UserProvider>(context, listen: false).loadUser();
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            height: 300,
            width: 300,
            child: Lottie.asset(
              'assets/data/splash_animation.json',
            )),
      ),
    );
  }
}
