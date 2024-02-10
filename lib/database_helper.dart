import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'user.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Initialize sqflite for desktop
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;

    final dbPath = await databaseFactory.getDatabasesPath();
    String path = join(dbPath, 'user_database.db');
    _database = await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          onCreate: (db, version) {
            return db.execute(
              'CREATE TABLE users(email TEXT PRIMARY KEY, password TEXT)',
            );
          },
          version: 1,
        ));
    return _database!;
  }

  static Future<void> insertUser(User user) async {
    final db = await DatabaseHelper.getDatabase();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<bool> authenticateUser(String email, String password) async {
    final db = await DatabaseHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    return maps.isNotEmpty;
  }
}
