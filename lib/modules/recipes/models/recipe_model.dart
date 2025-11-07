import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

enum RecipeSeason { spring, summer, autumn, winter }

enum RecipeDifficulty { easy, medium, hard }

class RecipeModel {
  final String id;
  final String name;
  final List<String> ingredients;
  final String preparationTime;
  final RecipeDifficulty difficulty;
  final List<String> steps;
  final bool isCooked;
  final RecipeSeason season;

  RecipeModel({
    String? id,
    required this.name,
    required this.ingredients,
    required this.season,
    required this.preparationTime,
    required this.difficulty,
    required this.steps,
    this.isCooked = false,
  }) : id = id ?? uuid.v4();

  RecipeModel copyWith({
    String? id,
    String? name,
    List<String>? ingredients,
    String? preparationTime,
    RecipeDifficulty? difficulty,
    List<String>? steps,
    bool? isCooked,
    RecipeSeason? season,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? List<String>.from(this.ingredients),
      season: season ?? this.season,
      preparationTime: preparationTime ?? this.preparationTime,
      difficulty: difficulty ?? this.difficulty,
      steps: steps ?? List<String>.from(this.steps),
      isCooked: isCooked ?? this.isCooked,
    );
  }
}
