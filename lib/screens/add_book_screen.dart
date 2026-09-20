import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/book.dart';
import '../widgets/rating_bar_widget.dart';

class AddBookScreen extends StatefulWidget {
  final Book? book;

  const AddBookScreen({super.key, this.book});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _titleController = TextEditingController();

  final _authorController = TextEditingController();

  double _rating = 3.0;

  @override
  void initState() {
    super.initState();
    // If we passed a book to edit, pre-fill the form fields
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _rating = widget.book!.rating;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  // Save book function triggered on button press
  void _saveBook() async {
    String enteredTitle = _titleController.text;
    String enteredAuthor = _authorController.text;

    if (enteredTitle.isEmpty || enteredAuthor.isEmpty) return;

    if (widget.book == null) {
      final newBook = Book(
        title: enteredTitle,
        author: enteredAuthor,
        rating: _rating,
      );
      await DatabaseHelper.instance.insertBook(newBook);
    } else {
      // 2. Store values directly into SQLite database
      final updateBook = Book(
        id: widget.book!.id,
        title: enteredTitle,
        author: enteredAuthor,
        rating: _rating,
      );
      await DatabaseHelper.instance.updateBook(updateBook);
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit book' : 'Add book'),
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [IconButton(onPressed: _saveBook, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Book title',
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Book Author',
              ),
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StarRatingBar(
                  onRatingChanged: (newRating) {
                    setState(() {
                      _rating = newRating;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: Text(isEditing ? 'Update book' : 'Save book'),
              onPressed: () {
                _saveBook();
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
