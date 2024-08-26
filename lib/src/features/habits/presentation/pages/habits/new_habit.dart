import 'package:flutter/material.dart';
import 'package:habit_on_assig/config/default/widgets/containers.dart';
import 'package:habit_on_assig/config/default/widgets/text.dart';
import 'package:habit_on_assig/src/features/habits/presentation/pages/model/habits_model.dart';

class NewHabitPage extends StatefulWidget {
  const NewHabitPage({super.key});

  @override
  State<NewHabitPage> createState() => _NewHabitPageState();
}

class _NewHabitPageState extends State<NewHabitPage> {
  late Future<HabitData> habitData;

  @override
  void initState() {
    super.initState();
    habitData = loadHabitData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var th = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Container(
            child: FutureBuilder<HabitData>(
                future: habitData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading habits'));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.13,
                          child: const TextDef(
                            "Start a new habit!",
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 1100,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 3 / 4,
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: data.habits.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "/createHabit",
                                      arguments: data.habits[index]);
                                },
                                child: CustomContainer(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(data.habits[index].image),
                                      TextDef(
                                        data.habits[index].name,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ),
      ),
    );
  }
}
