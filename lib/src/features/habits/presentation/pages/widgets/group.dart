import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/default/widgets/containers.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/habit_provider.dart';
import 'package:provider/provider.dart';

class HabitGroupSelector extends StatefulWidget {
  final List<HabitEntity> habits;

  const HabitGroupSelector({super.key, required this.habits});

  @override
  _HabitGroupSelectorState createState() => _HabitGroupSelectorState();
}

class _HabitGroupSelectorState extends State<HabitGroupSelector> {
  @override
  Widget build(BuildContext context) {
    String selectedGroup = context.watch<HabitProvider>().sort!;
    List<HabitEntity> habitList = _filterHabits(widget.habits, selectedGroup);
    var size = MediaQuery.of(context).size;
    var th = Theme.of(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          DateTime currentDate = DateTime.now();
          DateTime today =
              DateTime(currentDate.year, currentDate.month, currentDate.day);
          String colorString = habitList[index].color;

          String colorCode = colorString.substring(
              colorString.indexOf('(') + 1, colorString.indexOf(')'));

          int count = habitList[index].doneDates.where((date) {
            DateTime dateWithoutTime =
                DateTime(date.year, date.month, date.day);
            return dateWithoutTime == today;
          }).length;

          double progress =
              (size.width * 0.9 / habitList[index].repeatPerDay) * count;
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: CustomContainer(
              color: th.brightness == Brightness.dark
                  ? null
                  : th.primaryColorDark.withOpacity(0.6),
              height: size.height * 0.15,
              gradient: th.brightness == Brightness.dark
                  ? null
                  : LinearGradient(
                      colors: [
                        Color(int.parse(colorCode)),
                        Colors.purple[100]!
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              ontap: () {
                Navigator.pushNamed(
                  context,
                  "/viewHabit",
                  arguments: habitList[index],
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: habitList.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: Image.asset(habitList[index].icon)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 13.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextDef(
                                      habitList[index].name,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    TextDef(
                                      habitList[index].category,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: th.indicatorColor.withOpacity(0.4),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              TextDef(
                                "Streak\n    ${habitList[index].streak.toString()}",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: th.indicatorColor.withOpacity(0.4),
                              ),
                            ],
                          ),
                          const Spacer(),
                          TextDef(
                            "$count/${habitList[index].repeatPerDay}",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          CustomContainer(
                            width: size.width * 0.9,
                            height: 5,
                            child: Row(
                              children: [
                                CustomContainer(
                                  width: count == 0 ? 0 : progress - 17,
                                  height: 5,
                                  color: th.hintColor,
                                ),
                              ],
                            ),
                          ),
                          const SpaceY(20)
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
          );
        },
        childCount: habitList.length,
      ),
    );
  }

  // Widget buildGroupSelector() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       _buildGroupButton('Completed Today'),
  //       _buildGroupButton('Not Completed Today'),
  //       _buildGroupButton('All'),
  //     ],
  //   );
  // }

  // Widget _buildGroupButton(String group) {
  //   return ElevatedButton(
  //     onPressed: () {
  //       setState(() {
  //         selectedGroup = group;
  //       });
  //     },
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: selectedGroup == group ? Colors.blue : Colors.grey,
  //     ),
  //     child: Text(group),
  //   );
  // }

  List<HabitEntity> _filterHabits(List<HabitEntity> habits, String group) {
    DateTime today = DateTime.now();

    if (group == 'Completed Today') {
      return habits.where((habit) {
        int completedToday = habit.doneDates
            .where((date) =>
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day)
            .length;
        return completedToday >= habit.repeatPerDay;
      }).toList();
    } else if (group == 'Not Completed Today') {
      return habits.where((habit) {
        int completedToday = habit.doneDates
            .where((date) =>
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day)
            .length;
        return completedToday < habit.repeatPerDay;
      }).toList();
    } else {
      return habits;
    }
  }
}

class SelectContainer extends StatelessWidget {
  const SelectContainer({
    super.key,
    required this.value,
  });
  final String value;

  @override
  Widget build(BuildContext context) {
    bool isSelected = context.read<HabitProvider>().sort == value;

    return GestureDetector(
      onTap: () {
        context.read<HabitProvider>().sort = value;
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.grey,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
