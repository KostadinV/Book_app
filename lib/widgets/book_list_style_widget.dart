import 'package:flutter/material.dart';

import '../models/book.dart';

enum BookMenuAction { edit, delete }

class BookListTile extends StatelessWidget {
  final Book book;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookListTile({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('By ${book.author}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRatingBadge(),
            const SizedBox(width: 4),
            _buildActionMenu(context),
          ],
        ),
      ),
    );
  }

  // Помощен метод за визуалното показване на рейтинга
  Widget _buildRatingBadge() {
    return Text(
      '${book.rating} ★',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.amber.shade700,
      ),
    );
  }

  // Помощен метод за изскачащото меню (разделя логиката за по-добра четимост)
  Widget _buildActionMenu(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<BookMenuAction>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
