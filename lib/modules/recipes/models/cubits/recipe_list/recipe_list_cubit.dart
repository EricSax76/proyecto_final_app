import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_state.dart';
import 'package:todo_app_cifo/modules/recipes/models/recipe_model.dart';

class RecipeListCubit extends Cubit<RecipeListState> {
  RecipeListCubit() : super(RecipeListState.initial()) {
    _calculatePendingRecipes();
  }

  void toggleRecipe(String id) {
    final List<RecipeModel> updatedRecipes = state.recipes.map((recipe) {
      if (recipe.id == id) {
        return recipe.copyWith(isCooked: !recipe.isCooked);
      }
      return recipe;
    }).toList();

    _calculatePendingRecipes(recipes: updatedRecipes);
  }

  void changeFilter(RecipeFilter filter) {
    _calculatePendingRecipes(filter: filter);
  }

  void addRecipe(RecipeModel newRecipe) {
    final List<RecipeModel> updatedRecipes = [
      ...state.recipes,
      newRecipe,
    ];

    _calculatePendingRecipes(
      recipes: updatedRecipes,
      filter: RecipeFilter.all,
    );
  }

  void deleteRecipe(String recipeId) {
    final List<RecipeModel> updatedRecipes = state.recipes
        .where((recipe) => recipe.id != recipeId)
        .toList();

    _calculatePendingRecipes(recipes: updatedRecipes);
  }

  void updateRecipe(RecipeModel updatedRecipe) {
    final List<RecipeModel> updatedRecipes = state.recipes.map((recipe) {
      if (recipe.id == updatedRecipe.id) {
        return updatedRecipe;
      }
      return recipe;
    }).toList();

    _calculatePendingRecipes(recipes: updatedRecipes);
  }

  void searchRecipes(String query) {
    final String trimmedQuery = query.trim().toLowerCase();
    _calculatePendingRecipes(searchQuery: trimmedQuery);
  }

  void _calculatePendingRecipes({
    List<RecipeModel>? recipes,
    RecipeFilter? filter,
    String? searchQuery,
  }) {
    final List<RecipeModel> updatedRecipes = recipes ?? state.recipes;
    final RecipeFilter updatedFilter = filter ?? state.filter;
    final String updatedSearchQuery = searchQuery ?? state.searchQuery;

    final int pendingRecipeCount =
        updatedRecipes.where((recipe) => !recipe.isCooked).length;
    final List<RecipeModel> filteredRecipes = updatedSearchQuery.isEmpty
        ? _filterRecipes(updatedRecipes, updatedFilter)
        : _searchRecipes(updatedRecipes, updatedSearchQuery);

    emit(
      state.copyWith(
        recipes: updatedRecipes,
        pendingRecipeCount: pendingRecipeCount,
        filteredRecipes: filteredRecipes,
        filter: updatedFilter,
        searchQuery: updatedSearchQuery,
      ),
    );
  }

  List<RecipeModel> _searchRecipes(
    List<RecipeModel> recipes,
    String query,
  ) {
    return recipes
        .where(
          (recipe) => recipe.name.toLowerCase().contains(query),
        )
        .toList();
  }

  List<RecipeModel> _filterRecipes(
    List<RecipeModel> recipes,
    RecipeFilter filter,
  ) {
    switch (filter) {
      case RecipeFilter.all:
        return List<RecipeModel>.from(recipes);
      case RecipeFilter.spring:
        return recipes
            .where((recipe) => recipe.season == RecipeSeason.spring)
            .toList();
      case RecipeFilter.summer:
        return recipes
            .where((recipe) => recipe.season == RecipeSeason.summer)
            .toList();
      case RecipeFilter.autumn:
        return recipes
            .where((recipe) => recipe.season == RecipeSeason.autumn)
            .toList();
      case RecipeFilter.winter:
        return recipes
            .where((recipe) => recipe.season == RecipeSeason.winter)
            .toList();
    }
  }
}
