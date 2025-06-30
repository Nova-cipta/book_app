import 'package:book_app/core/util/static.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  /// set up & initiate sqflite [Database]
  Future<Database> initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/$dbBookApp.db';

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade
    );
    return db;
  }

  void _onUpgrade(Database db, int before, int after) {
    if (before < after) {
      db.delete(tbBooks);
      _onCreate(db, after);
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tbBooks (
        id INTEGER PRIMARY KEY,
        title TEXT,
        summaries TEXT,
        liked INTEGER,
        copyright INTEGER,
        media_type TEXT,
        formats TEXT,
        download_count INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbLanguages (
        book_id INTEGER,
        language TEXT,
        FOREIGN KEY (book_id) REFERENCES $tbBooks(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbSubjects (
        book_id INTEGER,
        subject TEXT,
        FOREIGN KEY (book_id) REFERENCES $tbBooks(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbBookshelves (
        book_id INTEGER,
        shelf TEXT,
        FOREIGN KEY (book_id) REFERENCES $tbBooks(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbAuthors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        birth_year INTEGER,
        death_year INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbBookAuthors (
        book_id INTEGER,
        author_id INTEGER,
        FOREIGN KEY (book_id) REFERENCES $tbBooks(id),
        FOREIGN KEY (author_id) REFERENCES $tbAuthors(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbTranslators (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        birth_year INTEGER,
        death_year INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE $tbBookTranslators (
        book_id INTEGER,
        translator_id INTEGER,
        FOREIGN KEY (book_id) REFERENCES $tbBooks(id),
        FOREIGN KEY (translator_id) REFERENCES $tbTranslators(id)
      );
    ''');
  }
}