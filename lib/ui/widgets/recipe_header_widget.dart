import 'package:flutter/material.dart';

class RecipeHeaderWidget extends StatelessWidget {
  final int count;

  const RecipeHeaderWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Daily Menu", style: TextStyle(fontSize: 20)),
        Text("Recetas por preparar: $count"),
      ],
    );
  }
}
