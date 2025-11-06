import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_cifo/cubits/recipe_list/recipe_list_cubit.dart';

class RecipeItemWidget extends StatelessWidget {
  final String desc;
  final String id;
  final bool isCooked;

  const RecipeItemWidget({
    super.key,
    required this.desc,
    required this.id,
    required this.isCooked,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(desc),
      leading: Checkbox(
        value: isCooked,
        onChanged: (_) {
          context.read<RecipeListCubit>().toggleRecipe(id);
        },
      ),
    );
  }
}
