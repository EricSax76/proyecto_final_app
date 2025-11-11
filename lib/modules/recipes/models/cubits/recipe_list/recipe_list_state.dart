import 'package:todo_app_cifo/modules/recipes/models/recipe_model.dart';
import 'package:todo_app_cifo/modules/recipes/utils/data.mock.dart';

enum RecipeFilter { all, spring, summer, autumn, winter }

class RecipeListState {
  final List<RecipeModel> recipes;
  final List<RecipeModel> filteredRecipes;
  final int pendingRecipeCount;
  final RecipeFilter filter;
  final String searchQuery;

  RecipeListState({
    required this.recipes,
    required this.filteredRecipes,
    required this.pendingRecipeCount,
    required this.filter,
    required this.searchQuery,
  });

  factory RecipeListState.initial() {
    final initialRecipes = List<RecipeModel>.from(recipesUserMock);
    return RecipeListState(
      recipes: initialRecipes,
      filteredRecipes: List<RecipeModel>.from(initialRecipes),
      pendingRecipeCount: 0,
      filter: RecipeFilter.all,
      searchQuery: '',
    );
  }

  RecipeListState copyWith({
    List<RecipeModel>? recipes,
    List<RecipeModel>? filteredRecipes,
    int? pendingRecipeCount,
    RecipeFilter? filter,
    String? searchQuery,
  }) {
    return RecipeListState(
      recipes: recipes ?? this.recipes,
      filteredRecipes: filteredRecipes ?? this.filteredRecipes,
      pendingRecipeCount: pendingRecipeCount ?? this.pendingRecipeCount,
      filter: filter ?? this.filter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
