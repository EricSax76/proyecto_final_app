import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app_cifo/router/app_router.dart';

class CreateRecipeWidget extends StatelessWidget {
  const CreateRecipeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.pushNamed(AppRouter.createRecipe.name),
      child: const Icon(Icons.add),
    );
  }
}
