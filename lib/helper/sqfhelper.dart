import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        """CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  title TEXT,
  description TEXT,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('local.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }
static Future<int> createItems({required String title, String? description})async{
  final db = await SqlHelper.db();
  final data  =  {'title': title, "description": description};
  final id = await db.insert('items', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
  return id;
}

static Future<List<Map<String,dynamic>>> getItems() async {
  final db = await SqlHelper.db();
  return db.query('items',orderBy: 'id');
}

}
