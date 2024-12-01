import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/gtask.dart';

//
class SharedPreferencesHelper {
  // Define keys for each field to be saved locally;
  static const String _userEmailKey = 'user_email';
  static const String _usernameKey = 'username';
  static const String _userKey = 'user_key';
  static const String _userTeamKey = 'user_team';

  // Save user email
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  // Retrieve user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Save username
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  // Retrieve username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // Save user password
  static Future<void> saveUserKey(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, password);
  }

  // // Can edit
  // static Future<String?> getKeys() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_userKey);
  // }

  // Save user team
  static Future<void> saveUserTeam(String team) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTeamKey, team);
  }

  // Retrieve user team
  static Future<String?> getUserTeam() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTeamKey);
  }

  // Check if user is logged in based on email presence
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userEmailKey);
  }

  // Clear all user profile data
  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_userKey);
    await prefs.remove(_userTeamKey);
  }

// Saving Guest todos Using shared preferences;
  late final SharedPreferences _sharedPreferences;
  SharedPreferencesHelper(this._sharedPreferences);
  // Save the list of todos
  static Future<void> saveTodoList(List<Task> todos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the list of todos to a list of JSON strings
    List<String> todosJson = todos.map((todo) => todo.toJson()).toList();

    // Save the list to SharedPreferences
    await prefs.setStringList('todo_list', todosJson.cast<String>());
  }

  // Retrieve the list of todos
  static Future<List<Task>> getTodoList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the saved list from SharedPreferences
    List<String>? todosJson = prefs.getStringList('todo_list');

    if (todosJson != null) {
      // Convert the list of JSON strings back to a list of Todo objects
      return todosJson.map((jsonString) => Task.fromJson(jsonString)).toList();
    }
    return [];
  }

  // Add a new todo to the existing list
  static Future<void> addTodo(Task newTodo) async {
    List<Task> todos = await getTodoList();
    todos.add(newTodo);
    await saveTodoList(todos);
  }

  // To Update the task
  static Future<void> updateTodo(Task updatedTodo) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> todosJson = prefs.getStringList('todos') ?? [];

    // Deserialize the list of tasks
    List<Task> todos =
        todosJson.map((todo) => Task.fromJson(jsonDecode(todo))).toList();

    // Find and update the task
    for (int i = 0; i < todos.length; i++) {
      if (todos[i].id == updatedTodo.id) {
        todos[i] = updatedTodo;
        break;
      }
    }

    // Save the updated list
    final updatedJson = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todos', updatedJson);
  }

  static Future<void> updateTodoStatus(String id, bool status) async {
    List<Task> todos = await getTodoList();
    for (int i = 0; i < todos.length; i++) {
      if (todos[i].id == id) {
        todos[i] = todos[i].copyWith(status: status);
        break;
      }
    }
    await saveTodoList(todos);
  }

  static Future<void> deleteTodo(String id) async {
    List<Task> todos = await getTodoList();
    todos.removeWhere((todo) => todo.id == id);
    await saveTodoList(todos);
  }
}
