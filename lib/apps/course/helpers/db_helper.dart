import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'courses.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE courses(idnumber TEXT PRIMARY KEY, name TEXT, id TEXT, clas TEXT, teacher TEXT, credit TEXT, courseType TEXT, location TEXT, period TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> deleteAllData(String table) async {
    final dbPath = await sql.getDatabasesPath();
    final sqlDb = await sql.openDatabase(path.join(dbPath, 'courses.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE courses(idnumber TEXT PRIMARY KEY, name TEXT, id TEXT, clas TEXT, teacher TEXT, credit TEXT, courseType TEXT, location TEXT, period TEXT)');
    }, version: 1);
    await sqlDb.execute('DELETE FROM $table');
  }
}
