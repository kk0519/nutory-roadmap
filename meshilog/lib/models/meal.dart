import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_item.dart';
import 'nutrition_facts.dart';

enum MealType { breakfast, lunch, dinner, snack }

class Meal {
  final String id;
  final String userId;
  final DateTime timestamp;
  final MealType mealType;
  final List<FoodItem> items;
  final String? note;

  const Meal({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.mealType,
    required this.items,
    this.note,
  });

  NutritionFacts get totals => items.fold(
    const NutritionFacts(calories: 0, proteinG: 0, fatG: 0, carbsG: 0),
    (sum, item) => sum + item.nutritionFacts,
  );

  factory Meal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Meal(
      id: doc.id,
      userId: data['user_id'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      mealType: MealType.values.byName(data['meal_type'] as String? ?? 'lunch'),
      items: (data['items'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      note: data['note'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'user_id': userId,
    'timestamp': Timestamp.fromDate(timestamp),
    'meal_type': mealType.name,
    'items': items.map((e) => e.toJson()).toList(),
    if (note != null) 'note': note,
  };
}
