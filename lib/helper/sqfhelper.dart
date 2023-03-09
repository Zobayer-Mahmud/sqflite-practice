// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper {
  static Future<void> createTables(sql.Database database,
      {String? tableName}) async {
    await database.execute(
        """CREATE TABLE ${tableName ?? 'items'}(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  title TEXT,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('local.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      print("Creating a table");
      await createTables(database);
    });
  }

  static Future<int> createItems(
      {required String title, String? description}) async {
    final db = await SqlHelper.db();
    final data = {
      'title': title,
      "description": description,
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    print("Gets a table");
    final db = await SqlHelper.db();
    return db.query('items', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getItemByID(int id) async {
    print("Gets an item in a table");
    final db = await SqlHelper.db();
    return db.query('items', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      {required int id, required String title, String? description}) async {
    print("Update a table");
    final db = await SqlHelper.db();
    final data = {
      'title': title,
      'description': description,
    };
    print("==========");
    print(title);
    print(data);
    print(description);
    print(id);
    final result =
        await db.update('items', data, where: "id = ? ", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem({required int id}) async {
    final db = await SqlHelper.db();
    if (kDebugMode) {
      print("Delete an item in a table");
    }
    try {
      await db.delete('items', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      if (kDebugMode) {
        print("Something went wrong when deleting an item $e");
      }
    }
  }
}
