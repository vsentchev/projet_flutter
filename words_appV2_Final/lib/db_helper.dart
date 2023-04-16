import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String _dbName = 'mywords.db';
  static const int _dbVersion = 1;
  static const String _tableName = 'words';

  static Database? _db;

  static initDb() async {
    final String dbPath = await getDatabasesPath();
    final String path = dbPath + _dbName;
    final Database database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    _db = database;
  }

  static const String _createTable = '''
    CREATE TABLE IF NOT EXISTS $_tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      word TEXT NOT NULL
    )
  ''';

  static const String _dropTable = '''
    DROP TABLE IF EXISTS $_tableName
  ''';

  static _onCreate(Database db, int version) async {
    await db.execute(_createTable);
    //await insertWord('houssam', 'vassili');
  }

  static _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(_dropTable);
    await _onCreate(db, newVersion);
  }

  static Future<int> insertWord(String username, String word) async {
    final Map<String, dynamic> row = {
      'username': username,
      'word': word,
    };
    final int id = await _db!.insert(_tableName, row);
    return id;
  }

  static Future<void> deleteWords() async {
    await _db!.delete(_tableName);
  }

  static Future<void> deleteWord(int id) async {
    await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getWords() async {
    final List<Map<String, dynamic>> rows = await _db!.query(_tableName);
    return rows;
  }
}
