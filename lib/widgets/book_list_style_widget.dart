import 'package:flutter/material.dart';

import '../models/book.dart';
import 'book_action_menu.dart';

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
            BookActionMenu(onEdit: onEdit, onDelete: onDelete),
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
}
