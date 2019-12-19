import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'expenses.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE exp(id TEXT PRIMARY KEY, title TEXT,description TEXT, date TEXT, amount REAL, image TEXT)');
    }, version: 1);
  }

   Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

   Future<List<Map<String, dynamic>>> getData(String table) async {
     
    final db = await DBHelper.database();
    return db.query(table);
  }


  Future<void> updateExp(String table,Map<String, Object> data)async{
    final db = await DBHelper.database();
   db.insert(table, data,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteExp(String table, String id)async{
    final db = await DBHelper.database();
    await db
    .rawDelete('DELETE FROM $table WHERE id = ?', ['$id']);
  }
}
