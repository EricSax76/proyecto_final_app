import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_state.dart';

class FilterButton extends StatelessWidget {
  final RecipeFilter filter;

  const FilterButton({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListCubit, RecipeListState>(
      buildWhen: (previous, current) => previous.filter != current.filter,
      builder: (context, state) {
        final bool isSelected = state.filter == filter;

        final TextStyle textStyle = TextStyle(
          fontSize: 18,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.black87,
        );

        return TextButton(
          onPressed: () => context.read<RecipeListCubit>().changeFilter(filter),
          child: Text(_filterLabel(filter), style: textStyle),
        );
      },
    );
  }

  String _filterLabel(RecipeFilter filter) {
    switch (filter) {
      case RecipeFilter.all:
        return "Todas";
      case RecipeFilter.spring:
        return "Primavera";
      case RecipeFilter.summer:
        return "Verano";
      case RecipeFilter.autumn:
        return "Otoño";
      case RecipeFilter.winter:
        return "Invierno";
    }
  }
}
