import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:todo_app_cifo/cubits/recipe_list/recipe_list_state.dart';
import 'package:todo_app_cifo/ui/widgets/recipe_header_widget.dart';
import 'package:todo_app_cifo/ui/widgets/recipe_item_widget.dart';
import 'package:todo_app_cifo/ui/widgets/search_filter_recipe_widget.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          BlocBuilder<RecipeListCubit, RecipeListState>(
            builder: (context, state) {
              return RecipeHeaderWidget(count: state.pendingRecipeCount);
            },
          ),
          SizedBox(height: 50),
          SearchFilterRecipeWidget(),
          BlocBuilder<RecipeListCubit, RecipeListState>(
            builder: (context, state) {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.filteredRecipes[index];
                  return RecipeItemWidget(
                    desc: recipe.desc,
                    isCooked: recipe.isCooked,
                    id: recipe.id,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
