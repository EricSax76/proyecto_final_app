import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

enum RecipeSeason { spring, summer, autumn, winter }

class RecipeModel {
  final String id;
  final String desc;
  final bool isCooked;
  final RecipeSeason season;

  RecipeModel({
    String? id,
    required this.desc,
    required this.season,
    this.isCooked = false,
  }) : id = id ?? uuid.v4();
}
