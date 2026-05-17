import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal.dart';

final mealRepositoryProvider = Provider((ref) => MealRepository(FirebaseFirestore.instance));

class MealRepository {
  final FirebaseFirestore _db;

  MealRepository(this._db);

  Stream<List<Meal>> todayMeals(String userId, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return _db
        .collection('users')
        .doc(userId)
        .collection('meals')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timestamp', isLessThan: Timestamp.fromDate(end))
        .orderBy('timestamp')
        .snapshots()
        .map((s) => s.docs.map(Meal.fromFirestore).toList());
  }

  Future<void> addMeal(String userId, Meal meal) => _db
      .collection('users')
      .doc(userId)
      .collection('meals')
      .doc(meal.id)
      .set(meal.toFirestore());

  Future<void> deleteMeal(String userId, String mealId) => _db
      .collection('users')
      .doc(userId)
      .collection('meals')
      .doc(mealId)
      .delete();
}
