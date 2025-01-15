import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'wishlist.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE wishlist (
        id TEXT PRIMARY KEY,
        oppId TEXT NOT NULL
      )
    ''');
        print('Table wishlist created');

  }

  Future<int> insertWishlistItem(String id, String oppId) async {
    final db = await database;
    return await db.insert(
      'wishlist',
      {'id': id, 'oppId': oppId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getWishlistItems() async {
    final db = await database;
    return await db.query('wishlist');
  }

  Future<int> removeWishlistItem(String oppId) async {
    final db = await database;
    return await db.delete(
      'wishlist',
      where: 'oppId = ?',
      whereArgs: [oppId],
    );
  }
}
