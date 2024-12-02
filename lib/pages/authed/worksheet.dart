import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/button2.dart';
import '../../components/button3.dart';
import '../../models/task.dart';
import '../../services/localdb_config/db_provider.dart';
import '../../services/supabase_config/sb_auth.dart';
import 'all_task_page.dart';
import 'auth_user_page.dart';
import 'formpage.dart';

class WorkArea extends StatefulWidget {
  String userName;
  final String userEmail;
  WorkArea({required this.userEmail, super.key, required this.userName});

  @override
  State<WorkArea> createState() => _WorkAreaState();
}

// This Codes are for the main body of the app where tasks
// and todos are displayed.

class _WorkAreaState extends State<WorkArea> {
  DateTime? _lastPressedAt;
  Timer? _timer;
  List<Todo?> _todoList = [];
  bool _isOnline = true;
  bool isLoading = true;
  bool isLoggedIn = false; // Mock authentication status
  bool isUserInDatabase = false;
  final _auth = SBAuth();

  late StreamSubscription<InternetStatus> _internetSubscription;

  // The internet status is checked on startup
  // and the Local Todos is displayed.
  @override
  void initState() {
    super.initState();
    _initializeInternetChecker(); //Check internet status on init
    _checkLoginStatus(); // Check Login status
    _checkUserInDatabase(); // Call user email on init
  }

  //Check if app is Connected to the Internet
  Future<void> _initializeInternetChecker() async {
    _internetSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      setState(() {
        _isOnline = status == InternetStatus.connected;
      });

      if (_isOnline) {
        debugPrint(
            'Internet connected: Refresh to sync local todos with Supabase');
      } else {
        debugPrint('No internet connection');
      }
    });
  }

  // Check if the user is in the database on app startup
  Future<void> _checkUserInDatabase() async {
    final response = await Supabase.instance.client
        .from('user_credentials')
        .select()
        .eq('email', widget.userEmail)
        .single();

    setState(() {
      isUserInDatabase = response != null;
    });
  }

  // Method to check user login status
  Future<void> _checkLoginStatus() async {
    // Replace this with your actual login status check
    final isSignedIn = await _auth.getLoggedInUserName() != null;
    setState(() {
      isLoggedIn = isSignedIn;
    });
  }

  @override
  void dispose() {
    _internetSubscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  // Fetch all todos from local database
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

  // Calls all the Task data stored
  Future<void> loadData() async {
    await _loadLocalTodos();
  }

  // Creates todos and adds it to the local database
  void _addTodo(Todo newTodo) async {
    await AppDB.instance.addTodo(newTodo);
    _loadLocalTodos();
  }

  // Method to Log out the User from the app
  Future<void> _closesession() async {
    if (isUserInDatabase) {
      await _auth.logout();
      setState(() {
        isUserInDatabase = false;
      });
    }
    Navigator.pushNamed(context, '/guest');
  }

  // To navigate to the form page to create task
  void _navigateToAddTodoForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTodoScreen(
          onTodoAdded: _addTodo,
          userName: widget.userName,
        ),
      ),
    );
  }

  // UI build code block:
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return DefaultTabController(
      length: isLoggedIn ? 2 : 1,
      child: WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          if (_lastPressedAt == null ||
              now.difference(_lastPressedAt!) > Duration(seconds: 2)) {
            // If the last press was more than 2 seconds ago, reset the timer
            _lastPressedAt = now;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Press back again to exit')),
            );
            return false; // Prevent the default back button behavior
          }
          return exit(0); // Exit the app
        },
        child: Scaffold(
          // APP BAR
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('To-Do'),
            bottom: TabBar(
                indicator: const UnderlineTabIndicator(),
                automaticIndicatorColorAdjustment: false,
                tabs: [
                  const Tab(
                      child: Text(
                    'My Todo',
                    style: TextStyle(color: Colors.white),
                  )),
                  if (isLoggedIn)
                    const Tab(
                      child: Text(
                        'All Tasks',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                ]),
            centerTitle: true,
            backgroundColor: const Color.fromRGBO(19, 62, 135, 1),
            foregroundColor: Colors.white,
          ),

          //Codes for Drawer begin here
          endDrawer: SafeArea(
            child: Drawer(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/bg2.jpg'),
                          radius: 80,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          isUserInDatabase
                              ? widget.userName
                              : 'Guest User', //Display current logged in user email here.
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: _isOnline
                                        ? Colors.green
                                        : Colors
                                            .grey, //Turns grey to indicate user is not online.
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text('Online'),
                            ]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isLoggedIn)
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/edit_details');
                      },
                      title: ButnTyp2(
                          text: 'Edit User Information',
                          size: 20,
                          btnColor: const Color.fromRGBO(19, 62, 135, 10),
                          borderRadius: 5),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/statistics');
                    },
                    title: ButnTyp2(
                        text: 'Statistics',
                        size: 20,
                        btnColor: const Color.fromRGBO(19, 62, 135, 10),
                        borderRadius: 5),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/tNc');
                    },
                    title: ButnTyp2(
                        text: 'Terms and Conditions',
                        size: 20,
                        btnColor: const Color.fromRGBO(19, 62, 135, 10),
                        borderRadius: 5),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ListTile(
                    onTap: () {
                      _closesession();
                    },
                    title: ButnTyp3(
                        text: 'Log out',
                        size: 20,
                        btnColor: Colors.redAccent,
                        borderRadius: 5),
                  ),
                  // Container(
                  //   color: Colors.greenAccent,
                  //   height: screen.height * 0.03,
                  // )
                ],
              ),
            ),
          ),
          //DRAWER ENDS HERE

          //Body Codes Begin Here
          body: SafeArea(
              child: Container(
                  width: screen.width,
                  decoration:
                      //Background Image block:
                      const BoxDecoration(
                          color: Color.fromRGBO(243, 243, 224, 1)
                          // image: DecorationImage(
                          //     fit: BoxFit.cover, image: AssetImage('assets/bg3.jpg')),
                          ),
                  child: TabBarView(children: [
                    if (isLoggedIn) const OnlyUserTask(),
                    if (_isOnline) const AllTask()
                  ]))),
          //BODY ENDS HERE

          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromRGBO(19, 62, 135, 1),
            foregroundColor: Colors.white,
            hoverColor: Colors.white70,
            onPressed: _navigateToAddTodoForm,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
