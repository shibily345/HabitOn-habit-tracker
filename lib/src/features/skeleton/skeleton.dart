import 'package:flutter/material.dart';
import 'package:habit_on_assig/src/features/auth/presentation/pages/settings.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/habits/new_habit.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/home/home_page.dart';
import 'package:provider/provider.dart';

import 'providers/selected_page_provider.dart';
import 'widgets/custom_bottom_bar_widget.dart';

List<Widget> pages = [
  const HomePage(),
  const NewHabitPage(),
  const SettingsPage()
];

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedPage = Provider.of<SelectedPageProvider>(context).selectedPage;
    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: const CustomBottomBarWidget(),
    );
  }
}
