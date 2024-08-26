import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_on_assig/config/params/params.dart';
import 'package:habit_on_assig/src/features/habits/data/model/habit_model.dart';

abstract class HabitRemoteDataSource {
  Future<List<HabitModel>> getHabit({required HabitParams params});
  Future<String> addHabit({required AddHabitParams params});
}

class HabitRemoteDataSourceImpl implements HabitRemoteDataSource {
  HabitRemoteDataSourceImpl();

  @override
  Future<String> addHabit({required AddHabitParams params}) async {
    final id = params.id;
    final userId = id;
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc();

    await docRef.set(params.habit.toMap());

    return docRef.id;
  }

  @override
  Future<List<HabitModel>> getHabit({required HabitParams params}) async {
    final userId = params.id;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('habits')
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => HabitModel.fromMap(doc.data()))
        .toList();
  }
}
