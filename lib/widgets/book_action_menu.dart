import 'package:flutter/material.dart';

enum BookMenuAction { edit, delete }

class BookActionMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookActionMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<BookMenuAction>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      position: PopupMenuPosition.under,
      elevation: 3,
      onSelected: (action) {
        switch (action) {
          case BookMenuAction.edit:
            onEdit();
            break;
          case BookMenuAction.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<BookMenuAction>(
          value: BookMenuAction.edit,
          height: 48.0,
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              const Text('Редактирай'),
            ],
          ),
        ),
        const PopupMenuDivider(indent: 10.0, endIndent: 10.0),
        PopupMenuItem<BookMenuAction>(
          value: BookMenuAction.delete,
          height: 48.0,
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text('Изтрий', style: TextStyle(color: colorScheme.error)),
            ],
          ),
        ),
      ],
    );
  }
}
