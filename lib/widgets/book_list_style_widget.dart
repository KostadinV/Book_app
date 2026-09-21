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
    return ListTile(
      title: Text(book.title),
      subtitle: Text('By ${book.author}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${book.rating} ★',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
