import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/task.dart';

class DataBase {
  static final DataBase _instance = DataBase.internal();

  factory DataBase() => _instance;

  static Database _db;

  final String _dbName = 'todo.db';

  final String _tableName = 'task';

  final String _createTable = '''
  create table `task` ( 
  `id` integer primary key autoincrement, 
  `title` text not null,
  `description` text,
  `completed` integer not null,
  `create_time` text
  )
  ''';

  final String _initialSql = '''
  insert into `task` (
  `title`,
  `description`,
  `completed`,
  `create_time`
  ) values (
    'Slide left or right to delete task',
    'This is a demo',
    0,
    ''
  )
  ''';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DataBase.internal();

  initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, _dbName);
    var dataBase = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dataBase;
  }

  _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(_createTable);
    await db.execute(_initialSql);
  }

  closeDB() {
    if (_db != null) {
      _db.close();
      _db = null;
      if (kDebugMode) {
        print("SQFLITE: Database closed successfully！");
      }
    }
  }

  /// Add a task
  Future<Task> insert(Task task) async {
    var d = await db;
    task.id = await d.insert(_tableName, task.toMap());
    if (kDebugMode) {
      print("SQFLITE: Task added successfully!");
    }
    return task;
  }

  /// Delete task
  Future<int> delete(int id) async {
    var d = await db;
    var result = await d.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }

  /// Update task
  Future<int>update(Task task) async {
    var d = await db;
    return await d.update(_tableName, task.toMap(),
        where: "id = ?", whereArgs: [task.id]);
  }

  /// Query by conditions
  Future<List<Task>> getTaskBy({
    bool distinct,
    List<String> columns,
    String where,
    List whereArgs,
    String groupBy,
    String having,
    String orderBy,
    int limit,
    int offset
  }) async {
    var d = await db;
    List<Map<String, dynamic>> maps = await d.query(_tableName,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        offset: offset,
        limit: limit);
    return maps.map((v) => Task.fromMap(v)).toList();
  }

  /// Query all data
  Future<List<Task>> getAll() async {
    var d = await db;
    List<Map<String, dynamic>> maps = await d.query(_tableName,
        columns: ['id', 'title', 'description', 'completed', 'create_time']);
    return maps.map((it) => Task.fromMap(it)).toList();
  }
}