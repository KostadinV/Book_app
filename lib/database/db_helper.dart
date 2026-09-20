import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/book.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _db;

  DatabaseHelper._init();

  // 1. Get database instance (or open it if it doesn't exist yet)
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase('books.db');
    return _db!;
  }

  Future<Database> _initDatabase(String filePath) async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        rating REAL NOT NULL
      )
    ''');
  }

  // CREATE: Приема Book обект
  Future<int> insertBook(Book book) async {
    final db = await instance.database;
    return await db.insert('books', book.toMap());
  }

  // READ: Връща List<Book> вместо List<Map>
  Future<List<Book>> getBooks() async {
    final db = await instance.database;
    final result = await db.query('books', orderBy: 'id DESC');

    // Превръщаме всеки Map от базата в Book обект
    return result.map((json) => Book.fromMap(json)).toList();
  }

  // UPDATE: Приема Book обект
  Future<int> updateBook(Book book) async {
    final db = await instance.database;
    return await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // DELETE: Изтрива по id
  Future<int> deleteBook(int id) async {
    final db = await instance.database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}
