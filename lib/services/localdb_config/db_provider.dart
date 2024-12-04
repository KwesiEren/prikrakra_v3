import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/task.dart';

// Here is my Local database handler codes.
// Created a database 'todoDB' and table 'todoTable':
const String fileName = "todoDB.db";

class AppDB {
  //Initialize Database:
  AppDB._init();

  static final AppDB instance = AppDB._init();
  static Database? _database;

  Future<Database> get mydatabase async {
    if (_database != null) return _database!;
    _database = await _startDB(fileName);
    return _database!;
  }

  //Creating table and its column:
  Future _create(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName(
      $idFN TEXT PRIMARY KEY,
      $titleFN TEXT NOT NULL,
      $detailsFN TEXT,
      $taskTypeFN TEXT NOT NULL,
      $userFN TEXT NOT NULL,
      $teamFN TEXT,
      $crtedDateFN TEXT NOT NULL,
      $statusFN BOOLEAN NOT NULL,
      $isSyncedFN BOOLEAN NOT NULL
    )
    ''');
  }

  // Start database Method
  Future<Database> _startDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _create,
      onOpen: (db) {
        debugPrint("Database opened at: $path");
      },
      singleInstance: true,
    );
  }

  //Creating CRUD operations:

  // Create Todo Method
  Future<Todo> addTodo(Todo todo) async {
    // Insert entry into todoTable
    final db = await instance.mydatabase;
    await db.insert(tableName, todo.toJson());

    debugPrint("Inserted Todo with ID: ${todo.id}");

    return todo;
  }

  // Fetch all Todo Method
  Future<List<Todo?>> getAllTodo() async {
    // Fetch all elements in table
    final db = await instance.mydatabase;
    final result = await db.query(tableName, orderBy: "$idFN ASC");

    return result.map((json) => Todo.fromJson(json)).toList();
  }

  // Update status parameter of Todo Method
  Future<void> updateTodoStatus(String id, bool status) async {
    // Update element in status column by ID
    final db = await mydatabase;
    await db.update(
      tableName,
      {statusFN: status ? 1 : 0}, // Convert boolean to int for SQLite
      where: '$idFN = ?',
      whereArgs: [id],
    );
  }

  // Fetch specific users Todo Method
  Future<List<Todo?>> getUserTodos(String userId) async {
    final db = await instance.mydatabase;
    final result = await db.query(
      tableName,
      where: "$userFN = ?",
      whereArgs: [userId],
      orderBy: "$idFN ASC",
    );
    return result.map((json) => Todo.fromJson(json)).toList();
  }

  // Update isSync parameter of Todo Method
  Future<void> updateTodoSyncStatus(String id, bool isSynced) async {
    // Update sync status by ID
    final db = await mydatabase;
    await db.update(
      tableName,
      {isSyncedFN: isSynced ? 1 : 0},
      where: '$idFN = ?',
      whereArgs: [id],
    );
  }

  // Update user parameter of Todo Method
  Future<int> updateUsernameForTasks(
      String oldUsername, String newUsername) async {
    final db = await instance.mydatabase;

    // Update all tasks where user matches oldUsername
    final result = await db.update(
      tableName,
      {userFN: newUsername},
      where: '$userFN = ?',
      whereArgs: [oldUsername],
    );

    debugPrint("Updated $result tasks from $oldUsername to $newUsername.");
    return result; // Return the number of rows affected
  }

  // Update Todo Method
  Future<int> updateTodo(Todo todo) async {
    // Update element in table by ID
    final db = await instance.mydatabase;
    final result = await db.update(
      tableName,
      todo.toJson(),
      where: '$idFN = ?',
      whereArgs: [todo.id],
    );
    debugPrint("Updated Todo with ID: ${todo.id}, Rows affected: $result");
    return result;
  }

  // Delete Todo Method
  Future<int> deleteTodoById(String id) async {
    // Delete element in table by ID
    final db = await instance.mydatabase;
    final result = await db.delete(
      tableName,
      where: '$idFN = ?',
      whereArgs: [id],
    );
    debugPrint("Deleted Todo with ID: $id, Rows affected: $result");
    return result;
  }

  // Close database Method
  Future<void> closeDB() async {
    // Close Database
    final db = await instance.mydatabase;
    return db.close();
  }
}
