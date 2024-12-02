import 'package:flutter/material.dart';
import 'package:prikrakra_v3/services/supabase_config/sb_db.dart';
import 'package:prikrakra_v3/utils/shared_preferences_helper.dart';

import '../models/gtask.dart';
import '../models/task.dart';
import '../services/localdb_config/db_provider.dart';
import '../services/supabase_config/sb_auth.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final dbConfig = SupaDB();
  final _auth = SBAuth();
  final isLoading = true;

  List<Task?> _guestTask = [];
  List<Todo?> _userTask = [];
  String? catchUser;
  int userTasks = 0; // Changed to int
  int completedTasks = 0;
  int uncompletedTasks = 0;

  @override
  void initState() {
    _initLoginStatus();
    super.initState();
  }

  Future<void> _initLoginStatus() async {
    final isLoggedIn = await _auth.isLoggedIn();
    if (isLoggedIn) {
      // Retrieve the logged-in user's name
      final userName = await _auth.getLoggedInUserName();

      setState(() {
        catchUser = userName;
      });

      await _authedUserTaskStatistics();
    } else {
      await _fetchguestTaskStatistics();
    }
  }

  Future<void> _loadguestTodos() async {
    List<Task> todos = await SharedPreferencesHelper.getTodoList();
    setState(() {
      _guestTask = todos;
    });
  }

  Future<void> _loadUserTodos() async {
    final tasks = await AppDB.instance.getUserTodos(catchUser!);
    setState(() {
      _userTask = tasks;
    });
  }

  // Future<void> _initializeData() async {
  //   // Fetch task statistics
  //   await _fetchguestTaskStatistics();
  // }

  Future<void> _authedUserTaskStatistics() async {
    await _loadUserTodos();

    List<Todo?> _completedTask =
        _userTask.where((task) => task!.status == true).toList();
    List<Todo?> _uncompletedTask =
        _userTask.where((task) => task!.status == false).toList();

    final taskCount = _userTask.length;
    final completedCount = _completedTask.length;
    final uncompletedCount = _uncompletedTask.length;
    setState(() {
      userTasks = taskCount;
      completedTasks = completedCount;
      uncompletedTasks = uncompletedCount;
    });
  }

  Future<void> _fetchguestTaskStatistics() async {
    await _loadguestTodos();

    List<Task?> _completedTask =
        _guestTask.where((task) => task!.status == true).toList();
    List<Task?> _uncompletedTask =
        _guestTask.where((task) => task!.status == false).toList();

    final taskCount = _guestTask.length;
    final completedCount = _completedTask.length;
    final uncompletedCount = _uncompletedTask.length;
    setState(() {
      userTasks = taskCount;
      completedTasks = completedCount;
      uncompletedTasks = uncompletedCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(19, 62, 135, 1),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: screen.width,
            decoration:
                //Background Image block:
                const BoxDecoration(color: Color.fromRGBO(243, 243, 224, 1)
                    // image: DecorationImage(
                    //     fit: BoxFit.cover, image: AssetImage('assets/bg3.jpg')),
                    ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screen.width * 0.4,
                        height: screen.height * 0.25,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(96, 139, 193, 1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(148, 19, 15, 15),
                              offset: Offset(4, 3),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$userTasks',
                              style: const TextStyle(
                                  fontSize: 70, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Tasks created',
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: screen.width * 0.4,
                        height: screen.height * 0.25,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(208, 76, 175, 79),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(148, 19, 15, 15),
                              offset: Offset(4, 3),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$completedTasks', // Convert to string
                              style: const TextStyle(
                                  fontSize: 70, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'Tasks completed',
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  // width: screen.width * 0.5,
                  height: screen.height * 0.1,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(96, 139, 193, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(148, 19, 15, 15),
                        offset: Offset(4, 3),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$uncompletedTasks Tasks left to complete.', // Convert to string
                      style: const TextStyle(
                          fontSize: 25, color: Color.fromARGB(205, 0, 0, 0)),
                    ),
                  ),
                ),
                if (uncompletedTasks != 0)
                  Container(
                    child: const Text(
                        'You have still have work to finish, don\'t be a slacker!',
                        style: TextStyle(
                            fontSize: 16, color: Color.fromARGB(205, 0, 0, 0))),
                  )
                else
                  Container(
                    child: const Text(
                        textAlign: TextAlign.center,
                        'Well done!\nYou have completed all your tasks\n Congrats!',
                        style: TextStyle(
                            fontSize: 25, color: Color.fromARGB(134, 0, 0, 0))),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
