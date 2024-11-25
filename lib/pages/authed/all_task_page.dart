import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/view_list.dart';
import '../../models/task.dart';
import '../../services/localdb_config/db_provider.dart';
import '../../services/supabase_config/sb_db.dart';

class AllTask extends StatefulWidget {
  const AllTask({super.key});

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  Timer? _timer;
  List<Todo?> _todoList = [];

  bool isLoading = true;

  void initState() {
    super.initState();

    _loadLocalTodos(); // Call all local database task on init

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _runPeriodicFunction();
    });
  }

  void _runPeriodicFunction() async {
    // Place your logic here
    await _fetchMissingTodosFromSupabase();
    await _syncLocalTodosToSupabase();
    debugPrint('Sync is running every 30 seconds');
  }

  //Fetch all todos from local database
  Future<List> _loadLocalTodos() async {
    setState(() {
      isLoading = true;
    });
    try {
      final todos = await AppDB.instance.getAllTodo();
      setState(() {
        _todoList = todos.map((todo) {
          todo?.isSynced = false; // Mark as unsynced when loaded
          return todo;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
    return _todoList;
  }

  //Fetch missing todos from Supabase:
  Future<void> _fetchMissingTodosFromSupabase() async {
    final response = await SupaDB.getAllSB();

    // Verify if response is in List<Map<String, dynamic>> format or List<Todo>
    if (response is List<Map<String, dynamic>>) {
      // If response is in map format, parse it into Todo objects
      final supabaseTodos = response
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();

      // Compare and find missing todos
      final localTodos = await AppDB.instance.getAllTodo();
      final missingTodos = supabaseTodos.where((supabaseTodo) {
        return !localTodos.any((localTodo) => localTodo!.id == supabaseTodo.id);
      }).toList();

      // Add missing todos to the local database
      for (var task in missingTodos) {
        await AppDB.instance.addTodo(task as Todo);
      }
    } else if (response is List<Todo>) {
      // If response is already a list of Todo objects, use it directly
      final supabaseTodos = response;

      final localTodos = await AppDB.instance.getAllTodo();
      final missingTodos = supabaseTodos.where((supabaseTodo) {
        return !localTodos.any((localTodo) => localTodo!.id == supabaseTodo.id);
      }).toList();

      for (var todo in missingTodos) {
        await AppDB.instance.addTodo(todo);
      }
    } else {
      throw Exception("Unexpected response format from Supabase");
    }

    debugPrint("Missing todos have been successfully pulled from Supabase.");

    // Refresh the UI with the latest todos
    setState(() {
      _loadLocalTodos();
    });
  }

  // Sync local Todos to the Online database
  Future<void> _syncLocalTodosToSupabase() async {
    final unsyncedTodos = _todoList.where((todo) => !todo!.isSynced).toList();

    if (unsyncedTodos.isEmpty) {
      debugPrint("No unsynced todos to upload.");
      return;
    }

    // Prepare data for upsert with isSynced set to true for Supabase
    final upsertData = unsyncedTodos.map((todo) {
      final json = todo!.toJson();
      json['isSynced'] = true; // Set isSynced to true for Supabase
      return json;
    }).toList();

    final response =
        await Supabase.instance.client.from('todoTable').upsert(upsertData);

    if (response.error != null) {
      debugPrint("Failed to sync todos: ${response.error!.message}");
    } else {
      // Mark todos as synced in the local database
      for (var todo in unsyncedTodos) {
        todo!.isSynced = true;
        await AppDB.instance.updateTodoSyncStatus(todo.id!, true);
      }
      debugPrint("Successfully synced todos.");
    }

    setState(() {
      _loadLocalTodos(); // Refresh local todos list after syncing
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Center(
      child: RefreshIndicator(
        onRefresh: _syncLocalTodosToSupabase,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _todoList.isEmpty
                ? const Text(
                    'The list is empty!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(96, 139, 193, 100),
                    ),
                  )
                : ListView.builder(
                    itemCount: _todoList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      return Card(
                        // Made it so that when you long press on a card, you can edit the tasks
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(203, 220, 235, 1),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 3),
                                  blurRadius: 6,
                                )
                              ]),
                          child: ListTile(
                            // Edit Card contents here:
                            title: ViewTask(
                              taskName: _todoList[index]!.title,
                              taskDetail: _todoList[index]!.details,
                            ),
                            subtitle: Text(_todoList[index]!.user),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
