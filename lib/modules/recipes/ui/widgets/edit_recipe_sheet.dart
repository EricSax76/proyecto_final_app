import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/modules/recipes/models/cubits/recipe_list/recipe_list_cubit.dart';
import 'package:todo_app_cifo/modules/recipes/models/recipe_model.dart';

Future<void> showCreateRecipeSheet(BuildContext context) {
  return _showRecipeFormSheet(context: context, isEditing: false);
}

Future<void> showEditRecipeSheet(
  BuildContext context,
  RecipeModel recipe,
) {
  return _showRecipeFormSheet(
    context: context,
    recipe: recipe,
    isEditing: true,
  );
}

Future<void> _showRecipeFormSheet({
  required BuildContext context,
  RecipeModel? recipe,
  required bool isEditing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RecipeForm(
          recipe: recipe,
          isEditing: isEditing,
          showDragHandle: true,
        ),
      );
    },
  );
}

class RecipeForm extends StatefulWidget {
  final RecipeModel? recipe;
  final bool isEditing;
  final bool showDragHandle;

  const RecipeForm({
    super.key,
    required this.recipe,
    required this.isEditing,
    this.showDragHandle = false,
  });

  @override
  State<RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _timeController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _stepsController;
  late final TextEditingController _imageController;
  late bool _isCooked;
  late RecipeDifficulty _difficulty;
  late RecipeSeason _season;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.recipe?.name ?? '');
    _timeController =
        TextEditingController(text: widget.recipe?.preparationTime ?? '');
    _ingredientsController = TextEditingController(
      text: widget.recipe?.ingredients.join('\n') ?? '',
    );
    _stepsController = TextEditingController(
      text: widget.recipe?.steps.join('\n') ?? '',
    );
    _imageController =
        TextEditingController(text: widget.recipe?.imageUrl ?? '');
    _isCooked = widget.recipe?.isCooked ?? false;
    _difficulty = widget.recipe?.difficulty ?? RecipeDifficulty.easy;
    _season = widget.recipe?.season ?? RecipeSeason.spring;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() != true) return;

    final String trimmedImage = _imageController.text.trim();
    final String? normalizedImage =
        trimmedImage.isEmpty ? null : trimmedImage;

    final RecipeModel updatedRecipe = widget.recipe?.copyWith(
          name: _nameController.text.trim(),
          preparationTime: _timeController.text.trim(),
          ingredients: _splitMultilineText(_ingredientsController.text),
          steps: _splitMultilineText(_stepsController.text),
          difficulty: _difficulty,
          season: _season,
          isCooked: _isCooked,
          imageUrl: normalizedImage,
        ) ??
        RecipeModel(
          name: _nameController.text.trim(),
          preparationTime: _timeController.text.trim(),
          ingredients: _splitMultilineText(_ingredientsController.text),
          steps: _splitMultilineText(_stepsController.text),
          difficulty: _difficulty,
          season: _season,
          isCooked: _isCooked,
          imageUrl: normalizedImage,
        );

    final recipeCubit = context.read<RecipeListCubit>();
    if (widget.isEditing) {
      recipeCubit.updateRecipe(updatedRecipe);
    } else {
      recipeCubit.addRecipe(updatedRecipe);
    }
    Navigator.of(context).pop();
  }

  List<String> _splitMultilineText(String value) {
    return value
        .split(RegExp(r'[\n\r]+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showDragHandle)
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              Text(
                widget.isEditing ? 'Editar receta' : 'Nueva receta',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen (opcional)',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _timeController,
                decoration:
                    const InputDecoration(labelText: 'Tiempo de preparación'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<RecipeDifficulty>(
                initialValue: _difficulty,
                decoration: const InputDecoration(labelText: 'Dificultad'),
                items: RecipeDifficulty.values
                    .map(
                      (difficulty) => DropdownMenuItem(
                        value: difficulty,
                        child: Text(_difficultyLabel(difficulty)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _difficulty = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<RecipeSeason>(
                initialValue: _season,
                decoration: const InputDecoration(labelText: 'Estación'),
                items: RecipeSeason.values
                    .map(
                      (season) => DropdownMenuItem(
                        value: season,
                        child: Text(_seasonLabel(season)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _season = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ingredientsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Ingredientes (uno por línea)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stepsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Pasos (uno por línea)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _isCooked,
                title: const Text('¿Ya la cocinaste?'),
                onChanged: (value) => setState(() => _isCooked = value),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: Text(widget.isEditing ? 'Guardar cambios' : 'Crear'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _difficultyLabel(RecipeDifficulty difficulty) {
    switch (difficulty) {
      case RecipeDifficulty.easy:
        return 'Fácil';
      case RecipeDifficulty.medium:
        return 'Media';
      case RecipeDifficulty.hard:
        return 'Difícil';
    }
  }

  String _seasonLabel(RecipeSeason season) {
    switch (season) {
      case RecipeSeason.spring:
        return 'Primavera';
      case RecipeSeason.summer:
        return 'Verano';
      case RecipeSeason.autumn:
        return 'Otoño';
      case RecipeSeason.winter:
        return 'Invierno';
    }
  }
}
