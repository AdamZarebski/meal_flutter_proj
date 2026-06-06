import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'models/meal.dart';
import 'services/meal_api_service.dart';
import 'services/meal_local_database.dart';
import 'screen/meal_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("meals_box");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikacja Kulinarna',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<MealCategory>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = _pobierzDane();
  }

  Future<List<MealCategory>> _pobierzDane() async {
    try {
      final zSieci = await MealApiService.fetchCategories();
      final doBazy = zSieci.map((c) => c.toJson()).toList();
      await MealLocalDatabase.saveCategories(doBazy);
      return zSieci;
    } catch (e) {
      final zBazy = MealLocalDatabase.getCachedCategories();
      if (zBazy != null) {
        return zBazy.map((item) => MealCategory.fromJson(Map<String, dynamic>.from(item))).toList();
      }
      throw Exception("Brak internetu i brak danych w pamięci!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategorie potraw"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _futureCategories = _pobierzDane();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MealCategory>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "${snapshot.error}".replaceAll("Exception: ", ""),
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final dane = snapshot.data ?? [];

          return ListView.builder(
            itemCount: dane.length,
            itemBuilder: (context, index) {
              final kat = dane[index];
              return ListTile(
                leading: Image.network(
                  kat.thumb,
                  width: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.fastfood);
                  },
                ),
                title: Text(kat.name),
                subtitle: Text(kat.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealListScreen(categoryName: kat.name),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}