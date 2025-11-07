import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: 18,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : Colors.black87,
    );

    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: textStyle),
    );
  }
}
