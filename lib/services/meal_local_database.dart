import 'package:hive_ce/hive.dart';

class MealLocalDatabase {
  static Box get _box => Hive.box("meals_box");

  static Future<void> saveCategories(List<dynamic> categoriesJson) async {
    await _box.put('categories', categoriesJson);
  }

  static List<dynamic>? getCachedCategories() {
    return _box.get('categories');
  }

  static Future<void> saveMeals(String category, List<dynamic> mealsJson) async {
    await _box.put('meals_' + category, mealsJson);
  }

  static List<dynamic>? getCachedMeals(String category) {
    return _box.get('meals_' + category);
  }
}