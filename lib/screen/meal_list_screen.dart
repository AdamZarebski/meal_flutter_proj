import 'package:flutter/material.dart';
import '../services/meal_api_service.dart';
import '../services/meal_local_database.dart';
import '../models/meal.dart';

class MealListScreen extends StatefulWidget {
  final String categoryName;
  const MealListScreen({super.key, required this.categoryName});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  late Future<List<MealSummary>> _futureMeals;

  @override
  void initState() {
    super.initState();
    _futureMeals = _pobierzDania();
  }

  Future<List<MealSummary>> _pobierzDania() async {
    try {
      final zSieci = await MealApiService.fetchMealsByCategory(widget.categoryName);
      final doBazy = zSieci.map((m) => m.toJson()).toList();
      await MealLocalDatabase.saveMeals(widget.categoryName, doBazy);
      return zSieci;
    } catch (e) {
      final zBazy = MealLocalDatabase.getCachedMeals(widget.categoryName);
      if (zBazy != null) {
        return zBazy.map((item) => MealSummary.fromJson(Map<String, dynamic>.from(item))).toList();
      }
      throw Exception("Brak danych offline dla tej kategorii.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: FutureBuilder<List<MealSummary>>(
        future: _futureMeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}".replaceAll("Exception: ", ""),
                  style: TextStyle(color: Colors.red)),
            );
          }

          final dania = snapshot.data ?? [];

          return ListView.builder(
            itemCount: dania.length,
            itemBuilder: (context, index) {
              final danie = dania[index];
              return ListTile(
                leading: Image.network(
                  danie.thumb,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Icon(Icons.cookie),
                ),
                title: Text(danie.name),
              );
            },
          );
        },
      ),
    );
  }
}