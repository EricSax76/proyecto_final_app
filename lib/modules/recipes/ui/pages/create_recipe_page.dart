import 'package:flutter/material.dart';
import 'package:todo_app_cifo/modules/recipes/ui/widgets/edit_recipe_sheet.dart';

class CreateRecipePage extends StatelessWidget {
  const CreateRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear receta')),
      body: SafeArea(
        child: RecipeForm(
          recipe: null,
          isEditing: false,
        ),
      ),
    );
  }
}
