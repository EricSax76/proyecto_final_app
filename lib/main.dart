import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:todo_app_cifo/ui/pages/recipes_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RecipeListCubit>(
      create: (context) => RecipeListCubit(),
      child: MaterialApp(home: RecipesPage()),
    );
  }
}
