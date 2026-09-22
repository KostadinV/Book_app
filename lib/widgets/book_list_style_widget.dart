import 'package:flutter/material.dart';

import '../models/book.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

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
            Text(
              '${book.rating} ★',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade700,
              ),
            ),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              // Заоблени ъгли и сянка по M3 стандарт
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'edit',
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
                PopupMenuDivider(indent: 10.0, endIndent: 10.0),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        size: 20,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Изтрий',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
