import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:habit_on_assig/config/default/widgets/containers.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';
import 'package:habit_on_assig/src/features/habits/presentation/providers/habit_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HabitStatisticsPage extends StatelessWidget {
  const HabitStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var ln = AppLocalizations.of(context)!;
    var th = Theme.of(context);
    return Consumer<HabitProvider>(
      builder: (context, hp, child) {
        final completionStats = hp.getHabitCompletionStats(hp.habit!);
        final lastSevenDays = completionStats.keys.toList()..sort();
        final barGroups = lastSevenDays.asMap().entries.map((entry) {
          final dayIndex = entry.key;
          final day = entry.value;
          final completionCount = completionStats[day] ?? 0;

          return BarChartGroupData(
            x: dayIndex,
            barRods: [
              BarChartRodData(
                  width: 15,
                  toY: completionCount.toDouble(),
                  color: th.primaryColor),
            ],
          );
        }).toList();
        return Scaffold(
          appBar: AppBar(
            title: TextDef(ln.yourHabitStatistics),
            actions: [
              IconButton(
                onPressed: () {
                  String statsMessage = hp.generateStatsMessage(hp.habit!);
                  Share.share(statsMessage);
                },
                icon: const Icon(Icons.share_rounded),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                CustomContainer(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      baselineY: 30,
                      // groupsSpace: 30,
                      barGroups: barGroups,
                      titlesData: FlTitlesData(
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: false), // Hide right titles
                        ),
                        topTitles: const AxisTitles(
                          sideTitles:
                              SideTitles(showTitles: false), // Hide top titles
                        ),
                        leftTitles: const AxisTitles(
                          drawBelowEverything: true,
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 100,
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final dayIndex = value.toInt();
                              final day = lastSevenDays[dayIndex];
                              final lastWeekdays =
                                  hp.last7days!.reversed.toList()[dayIndex];
                              final todayWeekday =
                                  DateFormat('EEE').format(lastWeekdays);
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: RotatedBox(
                                    quarterTurns: 1,
                                    child: TextDef(
                                        "${day.substring(5, 10)}  $todayWeekday")),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SpaceY(20),
                SizedBox(
                  height: 500,
                  width: size.width,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      final dayIndex = index;
                      final day = lastSevenDays.reversed.toList()[dayIndex];
                      final lastWeekdays =
                          hp.last7days!.reversed.toList()[dayIndex];
                      final todayWeekday =
                          DateFormat('EEE').format(lastWeekdays);
                      // final habitToDo = hp.filterHabitsByWeekdayAndDate(
                      //     hp.habit!, todayWeekday, DateTime.now());
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CustomContainer(
                          borderRadius: BorderRadius.circular(6),
                          height: 40,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextDef(
                                    "   ${day.substring(5, 10)}  $todayWeekday   "),
                                const Spacer(),
                                TextDef(ln.completionStats(
                                    completionStats[day].toString())),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SpaceY(100),
              ],
            ),
          ),
        );
      },
    );
  }
}
