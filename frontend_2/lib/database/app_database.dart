import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("app.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_session(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        userType TEXT,
        email TEXT,
        token TEXT
      )
    ''');
  }

  // Save session
  Future<void> saveSession(Map<String, dynamic> data) async {
    final db = await instance.database;

    // Clear any existing session
    await db.delete('user_session');

    await db.insert('user_session', data);
  }


  Future<Map<String, dynamic>?> loadSession() async {
    final db = await instance.database;
    final result = await db.query('user_session');

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> clearSession() async {
    final db = await instance.database;
    await db.delete('user_session');
  }
}