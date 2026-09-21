import 'package:flutter/material.dart';

import '../database/db_helper.dart';
import '../models/book.dart';
import '../widgets/book_list_style_widget.dart';
import 'add_book_screen.dart';

class MainBookScreen extends StatefulWidget {
  const MainBookScreen({super.key});

  @override
  State<MainBookScreen> createState() => _MainBookScreenState();
}

class _MainBookScreenState extends State<MainBookScreen> {
  List<Book> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshBooks();
  }

  // 2. Извличаме книгите от базата данни като List<Book>
  Future<void> _refreshBooks() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getBooks();
    setState(() {
      _books = data;
      _isLoading = false;
    });
  }

  // Open AddBookScreen, and refresh the list when user returns
  void _openAddBookScreen() async {
    // 1. Wait for user to finish on AddBookScreen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBookScreen()),
    );
    if (result == true) {
      _refreshBooks();
    }
  }

  // Метод за изтриване на книга директно от списъка
  Future<void> _deleteBook(int id) async {
    // 1. Изтриваме книгата от базата данни
    await DatabaseHelper.instance.deleteBook(id);
    // 3. Опресняваме списъка на екрана
    _refreshBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моите прочетени книги'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _books.isEmpty
          ? const Center(child: Text('No books saved in database yet.'))
          : ListView.builder(
              itemCount: _books.length,
              itemBuilder: (context, index) {
                final book = _books[index];
                return BookListTile(
                  book: book,
                  onEdit: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBookScreen(book: book),
                      ),
                    );

                    if (!context.mounted) return;
                    _refreshBooks();
                  },
                  onDelete: () => _deleteBook(book.id!),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddBookScreen(),
        label: const Text('Add book'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
