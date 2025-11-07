import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:todo_app_cifo/modules/recipes/models/recipe_model.dart';
import 'package:todo_app_cifo/router/app_router.dart';

class RecipeItemWidget extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeItemWidget({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.pushNamed(
          AppRouter.recipe.name,
          extra: recipe,
        );
      },
      title: Text(recipe.name),
      subtitle: Text(
        "${recipe.preparationTime} • ${_difficultyLabel(recipe.difficulty)}",
      ),
      leading: Checkbox(
        value: recipe.isCooked,
        onChanged: (_) {
          context.read<RecipeListCubit>().toggleRecipe(recipe.id);
        },
      ),
      trailing: Icon(Icons.chevron_right),
    );
  }

  String _difficultyLabel(RecipeDifficulty difficulty) {
    switch (difficulty) {
      case RecipeDifficulty.easy:
        return "Fácil";
      case RecipeDifficulty.medium:
        return "Media";
      case RecipeDifficulty.hard:
        return "Difícil";
    }
  }
}
