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
          onChanged: (value) {
            debugPrint('onChanged');
          },
          onSubmitted: (value) {
            debugPrint('onSubmitted');
          },
        ),
        SizedBox(height: 10),
        BlocBuilder<RecipeListCubit, RecipeListState>(
          builder: (context, state) {
            return Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 6,
              children: [
                FilterButton(
                  text: "Todas",
                  isSelected: state.filter == RecipeFilter.all,
                  onPressed: () => context.read<RecipeListCubit>().changeFilter(
                    RecipeFilter.all,
                  ),
                ),
                FilterButton(
                  text: "Primavera",
                  isSelected: state.filter == RecipeFilter.spring,
                  onPressed: () => context.read<RecipeListCubit>().changeFilter(
                    RecipeFilter.spring,
                  ),
                ),
                FilterButton(
                  text: "Verano",
                  isSelected: state.filter == RecipeFilter.summer,
                  onPressed: () => context.read<RecipeListCubit>().changeFilter(
                    RecipeFilter.summer,
                  ),
                ),
                FilterButton(
                  text: "Otoño",
                  isSelected: state.filter == RecipeFilter.autumn,
                  onPressed: () => context.read<RecipeListCubit>().changeFilter(
                    RecipeFilter.autumn,
                  ),
                ),
                FilterButton(
                  text: "Invierno",
                  isSelected: state.filter == RecipeFilter.winter,
                  onPressed: () => context.read<RecipeListCubit>().changeFilter(
                    RecipeFilter.winter,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
