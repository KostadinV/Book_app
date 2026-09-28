import 'package:flutter/material.dart';

import '../models/book.dart';
import 'book_action_menu.dart';
import 'rating_badge.dart';

class BookListTile extends StatelessWidget {
  final Book book;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const BookListTile({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleFavorite,
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
        subtitle: Text(book.author),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBadge(rating: book.rating),
            const SizedBox(width: 4),
            BookActionMenu(onEdit: onEdit, onDelete: onDelete),
            IconButton(
              icon: Icon(
                book.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: book.isFavorite ? Colors.red : null,
              ),
              tooltip: book.isFavorite
                  ? 'Премахни от любими'
                  : 'Добави в любими',
              onPressed: onToggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}
