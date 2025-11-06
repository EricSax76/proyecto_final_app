import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/cubits/recipe_list/recipe_list_state.dart';
import 'package:todo_app_cifo/models/recipe_model.dart';

class RecipeListCubit extends Cubit<RecipeListState> {
  RecipeListCubit() : super(RecipeListState.initial()) {
    calculatePendingRecipes();
  }

  void toggleRecipe(String id) {
    final List<RecipeModel> updatedRecipes = state.recipes.map((recipe) {
      if (recipe.id == id) {
        return RecipeModel(
          id: recipe.id,
          desc: recipe.desc,
          season: recipe.season,
          isCooked: !recipe.isCooked,
        );
      }
      return recipe;
    }).toList();

    calculatePendingRecipes(recipes: updatedRecipes);
  }

  void changeFilter(RecipeFilter filter) {
    calculatePendingRecipes(filter: filter);
  }

  void calculatePendingRecipes({
    List<RecipeModel>? recipes,
    RecipeFilter? filter,
  }) {
    final List<RecipeModel> updatedRecipes = recipes ?? state.recipes;
    final RecipeFilter updatedFilter = filter ?? state.filter;

    final int pendingRecipeCount =
        updatedRecipes.where((element) => !element.isCooked).length;
    final List<RecipeModel> filteredRecipes =
        _filterRecipes(updatedRecipes, updatedFilter);

    emit(
      state.copyWith(
        recipes: updatedRecipes,
        pendingRecipeCount: pendingRecipeCount,
        filteredRecipes: filteredRecipes,
        filter: updatedFilter,
      ),
    );
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
