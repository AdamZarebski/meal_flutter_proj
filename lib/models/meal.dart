class MealCategory {
  final String id;
  final String name;
  final String thumb;
  final String description;

  MealCategory({
    required this.id,
    required this.name,
    required this.thumb,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['idCategory'] ?? '',
      name: json['strCategory'] ?? '',
      thumb: json['strCategoryThumb'] ?? '',
      description: json['strCategoryDescription'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCategory': id,
      'strCategory': name,
      'strCategoryThumb': thumb,
      'strCategoryDescription': description,
    };
  }
}

class MealSummary {
  final String id;
  final String name;
  final String thumb;

  MealSummary({
    required this.id,
    required this.name,
    required this.thumb,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumb: json['strMealThumb'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumb,
    };
  }
}