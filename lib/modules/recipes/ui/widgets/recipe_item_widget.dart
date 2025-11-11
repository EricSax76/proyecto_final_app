import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:todo_app_cifo/modules/recipes/models/recipe_model.dart';
import 'package:todo_app_cifo/modules/recipes/ui/widgets/edit_recipe_sheet.dart';
import 'package:todo_app_cifo/router/app_router.dart';

class RecipeItemWidget extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeItemWidget({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(recipe.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: (_) => showEditRecipeSheet(context, recipe),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Editar',
          ),
          SlidableAction(
            onPressed: (_) =>
                context.read<RecipeListCubit>().deleteRecipe(recipe.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Eliminar',
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          context.pushNamed(
            AppRouter.recipe.name,
            extra: recipe,
          );
        },
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        leading: _RecipeThumbnail(imageUrl: recipe.imageUrl),
        title: Text(recipe.name),
        subtitle: Text(
          "${recipe.preparationTime} • ${_difficultyLabel(recipe.difficulty)}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: recipe.isCooked,
              onChanged: (_) {
                context.read<RecipeListCubit>().toggleRecipe(recipe.id);
              },
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
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

class _RecipeThumbnail extends StatelessWidget {
  final String? imageUrl;

  const _RecipeThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    const double size = 56;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _placeholder(size),
        ),
      );
    }

    return _placeholder(size);
  }

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.image, color: Colors.grey.shade600),
    );
  }
}
