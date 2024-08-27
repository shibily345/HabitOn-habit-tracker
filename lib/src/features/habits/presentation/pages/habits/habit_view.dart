import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_on_assig/config/default/widgets/containers.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';
import 'package:habit_on_assig/src/features/auth/presentation/providers/user_provider.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/widgets/calender.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/habit_provider.dart';
import 'package:provider/provider.dart';

class HabitView extends StatelessWidget {
  final HabitEntity habitEntity;
  const HabitView({super.key, required this.habitEntity});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).user!.uid;
    var size = MediaQuery.of(context).size;
    var th = Theme.of(context);
    var ln = AppLocalizations.of(context)!;

    return Consumer<HabitProvider>(
      builder: (context, habit, state) {
        int needToDone = habit.calculateTotalTimes(
            createdDate: habitEntity.createdAt,
            endDate: DateTime.now(),
            repeatPerDay: habitEntity.repeatPerDay,
            weekdays: habitEntity.days);
        double rate = habitEntity.doneDates.length / needToDone * 100;
        double roundedValue = double.parse(rate.toStringAsFixed(1));
        DateTime currentDate = DateTime.now();

        DateTime today =
            DateTime(currentDate.year, currentDate.month, currentDate.day);

        int count = habitEntity.doneDates.where((date) {
          DateTime dateWithoutTime = DateTime(date.year, date.month, date.day);
          return dateWithoutTime == today;
        }).length;

        print('Number of dates matching today: $count');
        bool isDoneAll = count >= habitEntity.repeatPerDay;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: TextDef(
                  habitEntity.name,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                pinned: true,
                expandedHeight: 10.0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.pause_circle_outline_sharp),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(context, "/updateHabit",
                          arguments: habitEntity);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      habit.deleteHabit(
                          userId:
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!
                                  .uid,
                          habitId: habitEntity.id);
                      Navigator.pushReplacementNamed(
                        context,
                        "/",
                      );
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 200.0,
                child: CustomContainer(
                  margin: const EdgeInsets.all(16),
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextDef(
                              ln.streak,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            TextDef(
                              "${habitEntity.streak} Days",
                              fontSize: 29,
                              fontWeight: FontWeight.w800,
                            ),
                            const SpaceY(20),
                            TextDef(
                              ln.currentStreak,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Image.asset(habitEntity.icon)
                      ],
                    ),
                  ),
                ),
              )),
              SliverToBoxAdapter(
                child: SizedBox(
                  width: size.width,
                  height: 205,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(
                          width: size.width * 0.44,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDef(
                                  ln.habitFinished,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextDef(
                                  ln.times(
                                      habitEntity.doneDates.length.toString()),
                                  fontSize: 29,
                                  fontWeight: FontWeight.w800,
                                ),
                                const SpaceY(20),
                                TextDef(
                                  ln.today(count.toString()),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                        CustomContainer(
                          width: size.width * 0.44,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDef(
                                  ln.completionRate,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                TextDef(
                                  ln.percentage(roundedValue.toString()),
                                  fontSize: 29,
                                  fontWeight: FontWeight.w800,
                                ),
                                const SpaceY(20),
                                TextDef(
                                  ln.habitProgress(
                                      habitEntity.doneDates.length.toString(),
                                      needToDone.toString()),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SizedBox(
                    height: 80,
                    child: CustomContainer(
                      ontap: () {
                        if (!isDoneAll) {
                          context
                              .read<HabitProvider>()
                              .updateHabitField(
                                  habitId: habitEntity.id,
                                  userId: userId,
                                  fieldName: 'doneDates',
                                  newValue:
                                      FieldValue.arrayUnion([DateTime.now()]))
                              .then((n) {
                            Navigator.pushReplacementNamed(context, "/");
                          });
                          if ((count + 1) == habitEntity.repeatPerDay) {
                            context
                                .read<HabitProvider>()
                                .updateHabitField(
                                    habitId: habitEntity.id,
                                    userId: userId,
                                    fieldName: 'streak',
                                    newValue: FieldValue.increment(1))
                                .then((n) {});
                          }
                        }
                      },
                      color: Colors.white.withOpacity(0.3),
                      width: 180,
                      height: 60,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextDef(
                              isDoneAll
                                  ? ln.successToday
                                  : ln.doneToday("${count + 1}",
                                      habitEntity.repeatPerDay.toString()),
                              fontSize: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 18.0,
                  ),
                  child: SizedBox(
                      height: 30,
                      child: TextDef(
                        ln.reminders,
                        fontSize: 20,
                      )),
                ),
              ),
              SliverToBoxAdapter(
                child: habitEntity.reminders.isEmpty
                    ? Text(ln.noTimesSelected)
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10, bottom: 10),
                        child: Wrap(
                          spacing: 15,
                          children: habitEntity.reminders.map((time) {
                            return CustomContainer(
                              width: 110,
                              height: 30,
                              borderRadius: BorderRadius.circular(5),
                              child: Center(
                                child: TextDef(
                                  time.substring(
                                      time.indexOf('(') + 1, time.indexOf(')')),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    top: 20,
                  ),
                  child: SizedBox(
                      height: 30,
                      child: TextDef(
                        ln.calendar,
                        fontSize: 20,
                      )),
                ),
              ),
              SliverToBoxAdapter(
                child: CustomContainer(
                  margin: const EdgeInsets.all(20),
                  child: CalenderWidget(
                    habitData: habitEntity,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
