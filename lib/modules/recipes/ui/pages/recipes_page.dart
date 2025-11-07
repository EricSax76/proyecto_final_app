import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_state.dart';
import 'package:todo_app_cifo/modules/recipes/ui/widgets/recipe_header_widget.dart';
import 'package:todo_app_cifo/modules/recipes/ui/widgets/recipe_item_widget.dart';
import 'package:todo_app_cifo/modules/recipes/ui/widgets/search_filter_recipe_widget.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              BlocBuilder<RecipeListCubit, RecipeListState>(
                builder: (context, state) {
                  return RecipeHeaderWidget(count: state.pendingRecipeCount);
                },
              ),
              const SizedBox(height: 32),
              const SearchFilterRecipeWidget(),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<RecipeListCubit, RecipeListState>(
                  builder: (context, state) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.filteredRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = state.filteredRecipes[index];
                        return RecipeItemWidget(recipe: recipe);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
