import 'package:flutter/material.dart';

class BookSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const BookSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: controller,
        autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: 'Search title or author...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            fontSize: 15,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: theme.colorScheme.onSurfaceVariant,
            onPressed: onClear,
            tooltip: 'Clear Search',
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
