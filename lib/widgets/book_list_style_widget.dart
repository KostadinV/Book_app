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
            RatingBadge(rating: book.rating),
            const SizedBox(width: 4),
            BookActionMenu(onEdit: onEdit, onDelete: onDelete),
          ],
        ),
      ),
    );
  }
}

class RatingBadge extends StatelessWidget {
  final double rating;
  const RatingBadge({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$rating *',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.amber.shade700,
      ),
    );
  }
}
