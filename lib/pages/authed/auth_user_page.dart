import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/todo_list.dart';
import '../../models/task.dart';
import '../../services/localdb_config/db_provider.dart';
import '../../services/supabase_config/sb_auth.dart';
import '../../services/supabase_config/sb_db.dart';
import 'updtetaskpage.dart';

class OnlyUserTask extends StatefulWidget {
  const OnlyUserTask({super.key});

  @override
  State<OnlyUserTask> createState() => _OnlyUserTaskState();
}

class _OnlyUserTaskState extends State<OnlyUserTask> {
  Timer? _timer;
  List<Todo?> _todoList = [];
  final bool _isOnline = true;
  bool isLoading = true;
  final _auth = SBAuth();

  @override
  void initState() {
    super.initState();
    // _initializeInternetChecker(); //Check internet status on init
    //loadData();
    //_loadLocalTodos();
    _loadUserTodos(); // Call all local database task on init
    // _checkUserInDatabase(); // Call user email on init
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

  

  Future<void> _loadUserTodos() async {
    setState(() {
      isLoading = true;
    });
    try {
      final userId = await _auth.getLoggedInUserName();
      final tasks = await AppDB.instance.getUserTodos(userId!);
      setState(() {
        _todoList = tasks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error loading user todos: $e");
    }
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
      for (var todo in missingTodos) {
        await AppDB.instance.addTodo(todo);
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
        //await SupaDB.updateSyncSB();
      }
    } else {
      throw Exception("Unexpected response format from Supabase");
    }

    debugPrint("Missing todos have been successfully pulled from Supabase.");

    // Refresh the UI with the latest todos
    setState(() {
      _loadUserTodos();
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
      _loadUserTodos(); // Refresh local todos list after syncing
    });
  }

  // Toggle status of a Task on local databse and online database, if only online
  void _toggleTodoStatus(int index) async {
    final updatedStatus = !_todoList[index]!.status;
    setState(() {
      _todoList[index]!.status = updatedStatus;
    });

    await AppDB.instance
        .updateTodoStatus(_todoList[index]!.id as String, updatedStatus);

    if (_isOnline) {
      final response = await Supabase.instance.client
          .from('todoTable')
          .update({'status': updatedStatus ? 1 : 0}).eq(
              'title', _todoList[index]!.title);

      if (response.error != null) {
        debugPrint(
            "Failed to update status in Supabase: ${response.error!.message}");
      } else {
        debugPrint(
            "Successfully updated status for Todo: ${_todoList[index]!.title}");
      }
    }
  }

  // Deletes todos from local database and online database, if only online
  void _deleteTodoById(String? id) async {
    await AppDB.instance.deleteTodoById(id!);
    _loadUserTodos();

    if (_isOnline) {
      final response = await Supabase.instance.client
          .from('todoTable')
          .delete()
          .eq('id', id);
      if (response.error != null) {
        debugPrint(
            "Failed to delete from Supabase: ${response.error!.message}");
      } else {
        debugPrint("Successfully deleted todo from Supabase");
      }
    }
  }

  @override
  void dispose() {
    // _internetSubscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      color: Color.fromRGBO(96, 139, 193, 100),
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
                        child: GestureDetector(
                          onLongPress: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EditTodoScreen(
                                  todo: _todoList[index],
                                  onTodoUpdated: (updatedTodo) {
                                    setState(() {
                                      _todoList[index] = updatedTodo;
                                    });
                                    _syncLocalTodosToSupabase();
                                  },
                                ),
                              ),
                            );
                          },
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
                              title: toDolist(
                                taskName: _todoList[index]!.title,
                                taskCompleted: _todoList[index]!.status,
                                onChanged: (value) => _toggleTodoStatus(index),
                                taskDetail: _todoList[index]!.details,
                              ),
                              subtitle: Text(_todoList[index]!.user),
                              trailing: IconButton(
                                onPressed: () =>
                                    _deleteTodoById(_todoList[index]!.id),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
