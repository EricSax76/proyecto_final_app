import 'package:flutter/material.dart';
import 'package:todo_app_cifo/modules/recipes/models/recipe_model.dart';

class RecipeDetailPage extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe.imageUrl!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported, size: 40),
                  ),
                ),
              )
            else
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.schedule,
              label: "Tiempo de preparación",
              value: recipe.preparationTime,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.terrain,
              label: "Estación",
              value: _seasonLabel(recipe.season),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.whatshot,
              label: "Dificultad",
              value: _difficultyLabel(recipe.difficulty),
            ),
            const SizedBox(height: 24),
            Text(
              "Ingredientes",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...recipe.ingredients.map(
              (ingredient) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• "),
                    Expanded(child: Text(ingredient)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text("Pasos", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...recipe.steps.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$index. "),
                    Expanded(child: Text(step)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  static String _difficultyLabel(RecipeDifficulty difficulty) {
    switch (difficulty) {
      case RecipeDifficulty.easy:
        return "Fácil";
      case RecipeDifficulty.medium:
        return "Media";
      case RecipeDifficulty.hard:
        return "Difícil";
    }
  }

  static String _seasonLabel(RecipeSeason season) {
    switch (season) {
      case RecipeSeason.spring:
        return "Primavera";
      case RecipeSeason.summer:
        return "Verano";
      case RecipeSeason.autumn:
        return "Otoño";
      case RecipeSeason.winter:
        return "Invierno";
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(
          "$label:",
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: textTheme.bodyMedium)),
      ],
    );
  }
}
