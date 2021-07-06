import 'dart:async';
import 'dart:io';

import 'package:flutter_todo_list/model/todo_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  DatabaseHelper();

  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();

  final String databaseName = "mydb.db";
  final String tableName = "todoTable";
  final String columnId = "id";
  final String columnItemName = "itemName";
  final String columnItemCreated = "itemCreated";

  static Database? _db;

  Future<Database> get db async => _db ??= await initDb();

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, databaseName);
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnItemName TEXT, $columnItemCreated TEXT)");
  }

  Future<int> saveItem(TodoItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", item.toMap());
    print(res.toString());
    return res;
  }

  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableName ORDER BY $columnItemName ASC");
    return result;
  }

  Future<TodoItem> getItem(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return TodoItem("", "");
    return new TodoItem.fromMap(result.first);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(TodoItem item) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
