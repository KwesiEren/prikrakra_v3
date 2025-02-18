import 'dart:async';

import 'package:flutter/material.dart';

import '../../components/view_list.dart';
import '../../models/task.dart';
import '../../services/supabase_config/sb_db.dart';

class AllTask extends StatefulWidget {
  const AllTask({super.key});

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  Timer? _timer;
  final dbConfig = SupaDB();
  List<Todo?> _alltodoList = [];

  bool isLoading = true;

  void initState() {
    super.initState();

    _loadAllTodos(); // Call all local database task on init

    _timer = Timer.periodic(const Duration(seconds: 120), (timer) {
      _runPeriodicFunction();
    });
  }

  void _runPeriodicFunction() async {
    // Place your logic here
    await _loadAllTodos();
    debugPrint('Sync is running every 30 seconds');
  }

  //Fetch all todos from local database
  Future<List> _loadAllTodos() async {
    setState(() {
      isLoading = true;
    });

    final response = await SupaDB.getAllSB();

    // Verify if response is in List<Map<String, dynamic>> format or List<Todo>
    if (response is List<Map<String, dynamic>>) {
      // If response is in map format, parse it into Todo objects
      final supabaseTodos = response
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();
      setState(() {
        _alltodoList = supabaseTodos;
      });
    } else if (response is List<Todo>) {
      // If response is already a list of Todo objects, use it directly
      final supabaseTodos = response;
      setState(() {
        _alltodoList = supabaseTodos;
        isLoading = false;
      });
    } else {
      throw Exception("Unexpected response format from Supabase");
    }

    return _alltodoList;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        onRefresh: _loadAllTodos,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _alltodoList.isEmpty
                ? const Text(
                    'The list is empty!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(96, 139, 193, 100),
                    ),
                  )
                : ListView.builder(
                    itemCount: _alltodoList.length,
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
                              taskName: _alltodoList[index]!.title,
                              taskDetail: _alltodoList[index]!.details,
                            ),
                            subtitle: Text(_alltodoList[index]!.user),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
