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
  List<Book> _filteredBooks = [];

  bool _isLoading = true;
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search title or author...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: _filterBooks,
              )
            : const Text('Моите прочетени книги'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _stopSearching,
              tooltip: 'Clear Search',
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              tooltip: 'Search Books',
            ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _BookListBody(
        isLoading: _isLoading,
        books: _filteredBooks,
        onEdit: (book) async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookScreen(book: book)),
          );
          if (!mounted) return;
          _refreshBooks();
        },
        onDelete: (id) => _deleteBook(id),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddBookScreen,
        label: const Text('Add book'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _refreshBooks() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getBooks();
    setState(() {
      _books = data;
      if (_isSearching && _searchController.text.isNotEmpty) {
        _filterBooks(_searchController.text);
      } else {
        _filteredBooks = data;
      }
      _isLoading = false;
    });
  }

  void _filterBooks(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = _books;
      } else {
        final searchLower = query.toLowerCase();
        _filteredBooks = _books.where((book) {
          final titleMatch = book.title.toLowerCase().contains(searchLower);
          final authorMatch = book.author.toLowerCase().contains(searchLower);
          return titleMatch || authorMatch;
        }).toList();
      }
    });
  }

  void _stopSearching() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _filteredBooks = _books;
    });
  }

  void _openAddBookScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBookScreen()),
    );
    if (result == true) {
      if (!context.mounted) return;
      _refreshBooks();
    }
  }

  Future<void> _deleteBook(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изтриване на книга'),
        content: const Text('Наистина ли искате да изтриете тази книга?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отказ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Изтрий', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await DatabaseHelper.instance.deleteBook(id);
      if (!mounted) return;
      _refreshBooks();
    }
  }
}

class _BookListBody extends StatelessWidget {
  final bool isLoading;
  final List<Book> books;
  final ValueChanged<Book> onEdit;
  final ValueChanged<int> onDelete;

  const _BookListBody({
    required this.isLoading,
    required this.books,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (books.isEmpty) {
      return const Center(child: Text('No books saved in database yet.'));
    }

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookListTile(
          book: book,
          onEdit: () => onEdit(book),
          onDelete: () => onDelete(book.id!),
        );
      },
    );
  }
}
