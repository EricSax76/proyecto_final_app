import 'package:todo_app_cifo/models/recipe_model.dart';

List<RecipeModel> recipesUserMock = [
  RecipeModel(
    desc: "Ensalada de primavera con espárragos",
    season: RecipeSeason.spring,
  ),
  RecipeModel(
    desc: "Gazpacho refrescante de verano",
    season: RecipeSeason.summer,
    isCooked: true,
  ),
  RecipeModel(
    desc: "Crema de calabaza otoñal",
    season: RecipeSeason.autumn,
  ),
  RecipeModel(
    desc: "Chocolate caliente especiado de invierno",
    season: RecipeSeason.winter,
  ),
];
