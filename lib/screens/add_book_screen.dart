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
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.book != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit book' : 'Add book'),
        actionsIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BookTextField(
                controller: _titleController,
                labelText: 'Book title',
                errorText: 'Моля, въведете заглавие на книгата',
              ),
              const SizedBox(height: 10),
              _BookTextField(
                controller: _authorController,
                labelText: 'Book Author',
                errorText: 'Моля, въведете автор на книгата',
              ),
              const SizedBox(height: 10),
              _BookRatingSection(
                onRatingChanged: (newRating) {
                  setState(() => _rating = newRating);
                },
              ),
              _BookSubmitButton(isEditing: isEditing, onPressed: _saveBook),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  void _saveBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
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
      final updateBook = Book(
        id: widget.book!.id,
        title: enteredTitle,
        author: enteredAuthor,
        rating: _rating,
      );
      await DatabaseHelper.instance.updateBook(updateBook);
    }
    if (!mounted) return;
    Navigator.pop(context, true);
  }
}

class _BookTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String errorText;

  const _BookTextField({
    required this.controller,
    required this.labelText,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorText;
        }
        return null;
      },
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
    );
  }
}

class _BookRatingSection extends StatelessWidget {
  final ValueChanged<double> onRatingChanged;

  const _BookRatingSection({required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [StarRatingBar(onRatingChanged: onRatingChanged)],
    );
  }
}

class _BookSubmitButton extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onPressed;

  const _BookSubmitButton({required this.isEditing, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(isEditing ? 'Update book' : 'Save book'),
    );
  }
}
