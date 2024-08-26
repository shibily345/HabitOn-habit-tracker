import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/default/widgets/containers.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';
import 'package:habit_on_assig/src/features/auth/presentation/providers/user_provider.dart';
import 'package:habit_on_assig/src/features/habits/business/entities/habit_entitie.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/habit_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var th = Theme.of(context);
    final userInfo = Provider.of<UserProvider>(context).user;
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.pushNamed(context, "/newHabit");
        //   },
        //   child: const TextDef(
        //     "+",
        //     fontSize: 30,
        //   ),
        // ),
        body: Consumer<HabitProvider>(
      builder: (context, habits, child) {
        List<HabitEntity> habitList1 = habits.habit!;
        List<HabitEntity> habitList =
            habits.filterHabitsByGroup(habitList1, habits.sort!);
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: false,
              title: TextDef(
                color: th.primaryColor,
                'HabitOn!',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              pinned: true,
              expandedHeight: 10.0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.pushNamed(context, "/settings");
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
                          const TextDef(
                            "Welcome!",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(
                            width: size.width * 0.52,
                            child: TextDef(
                              userInfo != null ? userInfo.displayName! : "",
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SpaceY(20),
                          SizedBox(
                            width: size.width * 0.52,
                            child: const TextDef(
                              "Create Habits That Stick, See Results That Shine.",
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Image.asset("assets/images/dart.png")
                    ],
                  ),
                ),
              ),
            )),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: SizedBox(
                  height: 50,
                  child: Wrap(
                    spacing: 5,
                    children: [
                      CustomContainer(
                        ontap: () {
                          habits.updateSort("nct");
                        },
                        color: habits.sort == "nct"
                            ? th.primaryColorDark.withOpacity(0.3)
                            : null,
                        width: 120,
                        height: 40,
                        borderRadius: BorderRadius.circular(10),
                        child: const Center(child: TextDef("Not Completed")),
                      ),
                      CustomContainer(
                        ontap: () {
                          habits.updateSort("ct");
                        },
                        color: habits.sort == "ct"
                            ? th.primaryColorDark.withOpacity(0.2)
                            : null,
                        width: 100,
                        height: 40,
                        borderRadius: BorderRadius.circular(10),
                        child: const Center(child: TextDef("Completed")),
                      ),
                      CustomContainer(
                        ontap: () {
                          habits.updateSort("nt");
                        },
                        color: habits.sort == "nt"
                            ? th.primaryColorDark.withOpacity(0.2)
                            : null,
                        width: 100,
                        height: 40,
                        borderRadius: BorderRadius.circular(10),
                        child: const Center(child: TextDef("Not Today")),
                      ),
                      CustomContainer(
                        ontap: () {
                          habits.updateSort("all");
                        },
                        color: habits.sort == "all"
                            ? th.primaryColorDark.withOpacity(0.2)
                            : null,
                        width: 60,
                        height: 40,
                        borderRadius: BorderRadius.circular(10),
                        child: const Center(child: TextDef("All")),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  DateTime currentDate = DateTime.now();
                  DateTime today = DateTime(
                      currentDate.year, currentDate.month, currentDate.day);
                  String colorString = habitList[index].color;

                  String colorCode = colorString.substring(
                      colorString.indexOf('(') + 1, colorString.indexOf(')'));

                  int count = habitList[index].doneDates.where((date) {
                    DateTime dateWithoutTime =
                        DateTime(date.year, date.month, date.day);
                    return dateWithoutTime == today;
                  }).length;

                  double progress =
                      (size.width * 0.9 / habitList[index].repeatPerDay) *
                          count;
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: Image.asset(
                                                habitList[index].icon)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 13.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              color: th.indicatorColor
                                                  .withOpacity(0.4),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      TextDef(
                                        "Streak\n    ${habitList[index].streak.toString()}",
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            th.indicatorColor.withOpacity(0.4),
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
            ),
          ],
        );
      },
    ));
  }
}
