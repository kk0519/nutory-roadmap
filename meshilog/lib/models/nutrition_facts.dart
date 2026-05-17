class NutritionFacts {
  final double calories;
  final double proteinG;
  final double fatG;
  final double carbsG;
  final double fiberG;
  final double saltG;

  const NutritionFacts({
    required this.calories,
    required this.proteinG,
    required this.fatG,
    required this.carbsG,
    this.fiberG = 0,
    this.saltG = 0,
  });

  NutritionFacts operator +(NutritionFacts other) => NutritionFacts(
    calories: calories + other.calories,
    proteinG: proteinG + other.proteinG,
    fatG: fatG + other.fatG,
    carbsG: carbsG + other.carbsG,
    fiberG: fiberG + other.fiberG,
    saltG: saltG + other.saltG,
  );

  factory NutritionFacts.fromJson(Map<String, dynamic> j) => NutritionFacts(
    calories: (j['calories'] as num).toDouble(),
    proteinG: (j['protein_g'] as num).toDouble(),
    fatG: (j['fat_g'] as num).toDouble(),
    carbsG: (j['carbs_g'] as num).toDouble(),
    fiberG: (j['fiber_g'] as num? ?? 0).toDouble(),
    saltG: (j['salt_g'] as num? ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'calories': calories,
    'protein_g': proteinG,
    'fat_g': fatG,
    'carbs_g': carbsG,
    'fiber_g': fiberG,
    'salt_g': saltG,
  };
}
