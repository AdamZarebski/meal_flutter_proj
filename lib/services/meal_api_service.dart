import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class MealApiService {
  static const String baseUrl = "https://www.themealdb.com/api/json/v1/1";

  static Future<List<MealCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse(baseUrl + "/categories.php"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['categories'];
      return list.map((item) => MealCategory.fromJson(item)).toList();
    } else {
      throw Exception("Blad pobierania danych");
    }
  }

  static Future<List<MealSummary>> fetchMealsByCategory(String categoryName) async {
    final response = await http.get(Uri.parse(baseUrl + "/filter.php?c=" + categoryName));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['meals'] ?? [];
      return list.map((item) => MealSummary.fromJson(item)).toList();
    } else {
      throw Exception("Blad pobierania dań");
    }
  }
}