import 'nutrition_facts.dart';

enum FoodSource { barcode, ocr, manual, photoAi }

class FoodItem {
  final String name;
  final double amountG;
  final NutritionFacts nutritionFacts;
  final String? janCode;
  final FoodSource source;

  const FoodItem({
    required this.name,
    required this.amountG,
    required this.nutritionFacts,
    this.janCode,
    this.source = FoodSource.manual,
  });

  factory FoodItem.fromJson(Map<String, dynamic> j) => FoodItem(
    name: j['name'] as String,
    amountG: (j['amount_g'] as num).toDouble(),
    nutritionFacts: NutritionFacts.fromJson(j['nutrition'] as Map<String, dynamic>),
    janCode: j['jan_code'] as String?,
    source: FoodSource.values.byName(j['source'] as String? ?? 'manual'),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount_g': amountG,
    'nutrition': nutritionFacts.toJson(),
    if (janCode != null) 'jan_code': janCode,
    'source': source.name,
  };
}
