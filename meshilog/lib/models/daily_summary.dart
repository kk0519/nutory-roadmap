import 'nutrition_facts.dart';

class DailySummary {
  final String date; // yyyy-MM-dd
  final NutritionFacts totals;
  final NutritionFacts targets;

  const DailySummary({
    required this.date,
    required this.totals,
    required this.targets,
  });

  double get calorieProgress => totals.calories / targets.calories;

  factory DailySummary.fromJson(Map<String, dynamic> j) => DailySummary(
    date: j['date'] as String,
    totals: NutritionFacts.fromJson(j['totals'] as Map<String, dynamic>),
    targets: NutritionFacts.fromJson(j['targets'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'date': date,
    'totals': totals.toJson(),
    'targets': targets.toJson(),
  };
}
