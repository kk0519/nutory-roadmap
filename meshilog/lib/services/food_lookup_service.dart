import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import 'open_food_facts_api.dart';

final foodLookupServiceProvider = Provider((ref) => FoodLookupService());

class FoodLookupService {
  final OpenFoodFactsApi _api = OpenFoodFactsApi();

  Future<FoodItem?> lookupByJan(String janCode) async {
    // Lookup chain: local SQLite (文科省DB) → Firestore cache → Open Food Facts API
    // TODO: Step 1 — check local SQLite
    // TODO: Step 2 — check Firestore cache
    // Step 3 — Open Food Facts API
    final result = await _api.lookup(janCode);
    if (result == null) return null;
    return FoodItem(
      name: result.name,
      amountG: 100,
      nutritionFacts: result.nutrition,
      janCode: janCode,
      source: FoodSource.barcode,
    );
  }
}
