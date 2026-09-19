import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  // 1. Get database instance (or open it if it doesn't exist yet)
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  static Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'book_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  // 3. Insert a new book entry into the table
  static Future<int> insertBook(
    String title,
    String author,
    double rating,
  ) async {
    final db = await database;
    return await db.insert('books', {
      'title': title,
      'author': author,
      'rating': rating,
    });
  }

  static Future<int> deleteBook(int id) async {
    final db = await database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id], // Uses the book's unique ID to target the exact row
    );
  }

  // In db_helper.dart

  static Future<int> updateBook(
    int id,
    String title,
    String author,
    double rating,
  ) async {
    final db = await database;
    return await db.update(
      'books',
      {'title': title, 'author': author, 'rating': rating},
      where: 'id = ?',
      whereArgs: [id], // Targets the specific book ID
    );
  }

  // 4. Fetch all books from the table
  static Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await database;
    return await db.query('books');
  }
}
