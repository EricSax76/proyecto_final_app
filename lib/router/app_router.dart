import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app_cifo/modules/recipes/models/recipe_model.dart';
import 'package:todo_app_cifo/modules/recipes/ui/pages/create_recipe_page.dart';
import 'package:todo_app_cifo/modules/recipes/ui/pages/recipe_detail_page.dart';
import 'package:todo_app_cifo/modules/recipes/ui/pages/recipes_page.dart';

enum AppRouter { home, recipe, createRecipe }

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRouter.home.name,
      builder: (context, state) => const RecipesPage(),
    ),
    GoRoute(
      path: '/recipe_detail',
      name: AppRouter.recipe.name,
      builder: (context, state) {
        final recipe = state.extra;
        if (recipe is! RecipeModel) {
          throw FlutterError(
            'RecipeDetailPage requires a RecipeModel in state.extra; '
            'received ${recipe.runtimeType}.',
          );
        }
        return RecipeDetailPage(recipe: recipe);
      },
    ),
    GoRoute(
      path: '/create_recipe',
      name: AppRouter.createRecipe.name,
      builder: (context, state) => const CreateRecipePage(),
    ),
  ],
);
