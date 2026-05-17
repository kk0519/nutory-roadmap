import 'package:dio/dio.dart';
import '../models/nutrition_facts.dart';

class OpenFoodFactsApi {
  static const _base = 'https://world.openfoodfacts.org/api/v0/product';
  final Dio _dio;

  OpenFoodFactsApi({Dio? dio}) : _dio = dio ?? Dio();

  Future<OpenFoodFactsResult?> lookup(String janCode) async {
    try {
      final res = await _dio.get('$_base/$janCode.json');
      final data = res.data as Map<String, dynamic>;
      if (data['status'] != 1) return null;
      final product = data['product'] as Map<String, dynamic>;
      final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};
      return OpenFoodFactsResult(
        name: product['product_name_ja'] as String? ??
            product['product_name'] as String? ??
            '不明',
        nutrition: NutritionFacts(
          calories: (nutriments['energy-kcal_100g'] as num? ?? 0).toDouble(),
          proteinG: (nutriments['proteins_100g'] as num? ?? 0).toDouble(),
          fatG: (nutriments['fat_100g'] as num? ?? 0).toDouble(),
          carbsG: (nutriments['carbohydrates_100g'] as num? ?? 0).toDouble(),
          fiberG: (nutriments['fiber_100g'] as num? ?? 0).toDouble(),
          saltG: (nutriments['salt_100g'] as num? ?? 0).toDouble(),
        ),
      );
    } on DioException {
      return null;
    }
  }
}

class OpenFoodFactsResult {
  final String name;
  final NutritionFacts nutrition;

  const OpenFoodFactsResult({required this.name, required this.nutrition});
}
