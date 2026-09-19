import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'package:my_aplication/add_book_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _myBooks = [];

  @override
  void initState() {
    super.initState();
    _refreshBooks();
  }

  void _refreshBooks() async {
    final data = await DatabaseHelper.getBooks();
    setState(() {
      _myBooks = data;
    });
  }

  // Open AddBookScreen, and refresh the list when user returns
  void _openAddBookScreen() async {
    // 1. Wait for user to finish on AddBookScreen
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBookScreen()),
    );

    // 2. Refresh the list from the database after returning!
    _refreshBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My book diary'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _myBooks.isEmpty
          ? const Center(child: Text('No books saved in database yet.'))
          : ListView.builder(
              itemCount: _myBooks.length,
              itemBuilder: (context, index) {
                final book = _myBooks[index];
                return ListTile(
                  title: Text(book['title']),
                  subtitle: Text('By ${book['author']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${book['rating']} ★',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          // Pass the selected book into AddBookScreen
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBookScreen(book: book),
                            ),
                          );

                          // Refresh list when returning from edit screen
                          _refreshBooks();
                        },
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          // 1. Delete from SQLite database using the book's ID
                          await DatabaseHelper.deleteBook(book['id']);

                          // 2. Refresh the list to remove it from the screen
                          _refreshBooks();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openAddBookScreen();
        },
        label: Text('Add book'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
