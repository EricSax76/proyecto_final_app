import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_state.dart';
import 'package:todo_app_cifo/modules/recipes/ui/widgets/filter_button.dart';

class SearchFilterRecipeWidget extends StatelessWidget {
  const SearchFilterRecipeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Buscar recetas...',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) =>
              context.read<RecipeListCubit>().searchRecipes(value),
          onSubmitted: (value) =>
              context.read<RecipeListCubit>().searchRecipes(value),
        ),
        SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 6,
          children: const [
            FilterButton(filter: RecipeFilter.all),
            FilterButton(filter: RecipeFilter.spring),
            FilterButton(filter: RecipeFilter.summer),
            FilterButton(filter: RecipeFilter.autumn),
            FilterButton(filter: RecipeFilter.winter),
          ],
        ),
      ],
    );
  }
}
