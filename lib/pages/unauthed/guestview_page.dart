import 'dart:io';

import 'package:flutter/material.dart';

import '../../components/button2.dart';
import '../../components/button3.dart';
import '../../components/guestview_list.dart';
import '../../models/gtask.dart';
import '../../utils/shared_preferences_helper.dart';
import 'addtodo_page.dart';
import 'edittodo_page.dart';

class GuestviewPage extends StatefulWidget {
  const GuestviewPage({super.key});

  @override
  State<GuestviewPage> createState() => _GuestviewPageState();
}

class _GuestviewPageState extends State<GuestviewPage> {
  List<Task?> _guestTask = [];
  DateTime? _lastPressedAt;

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Load todos when the screen initializes
  }

  Future<void> _opensession() async {
    Navigator.pushNamed(context, '/login');
  }

  // Method to fetch todos from SharedPreferences
  Future<void> _loadTodos() async {
    List<Task> todos = await SharedPreferencesHelper.getTodoList();
    setState(() {
      _guestTask = todos;
    });
  }

  void _toggleTodoStatus(int index) async {
    final updatedStatus = !_guestTask[index]!.status;
    setState(() {
      _guestTask[index]!.status = updatedStatus;
    });
    final updatedTodo = _guestTask[index];

    await SharedPreferencesHelper.updateTodo(updatedTodo!);

    _loadTodos();
  }

  // Method to delete a todo
  Future<void> _deleteTodo(String id) async {
    await SharedPreferencesHelper.deleteTodo(
        id); // Assuming a deleteTodo method exists
    _loadTodos(); // Reload the updated list
  }

  Future<void> _navigateToaddGuestTodo() async {
    final newTodo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddGuestTodoScreen(),
      ),
    );

    if (newTodo != null) {
      setState(() {
        _guestTask.add(newTodo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return WillPopScope(
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/bg2.jpg'),
                        radius: 80,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Guest User',
                        //Display current logged in user email here.
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 50,
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
                    Navigator.pushNamed(context, '/edwin');
                  },
                  title: ButnTyp2(
                      text: 'Terms and Conditions',
                      size: 20,
                      btnColor: const Color.fromRGBO(19, 62, 135, 10),
                      borderRadius: 5),
                ),
                const SizedBox(
                  height: 120,
                ),
                ListTile(
                  onTap: () {
                    _opensession();
                  },
                  title: ButnTyp3(
                      text: 'Log in',
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
                  const BoxDecoration(color: Color.fromRGBO(243, 243, 224, 1)
                      // image: DecorationImage(
                      //     fit: BoxFit.cover, image: AssetImage('assets/bg3.jpg')),
                      ),
              child: ListView.builder(
                  itemCount: _guestTask.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: GestureDetector(
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditGuestTodoScreen(
                                todo: _guestTask[index],
                                onTodoUpdated: (updatedTodo) {
                                  setState(() {
                                    // Update the todo in the local UI list
                                    final index = _guestTask.indexWhere(
                                        (todo) => todo!.id == updatedTodo.id);
                                    if (index != -1) {
                                      _guestTask[index] = updatedTodo;
                                    }
                                  });
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
                            title: GuestTask(
                              taskName: _guestTask[index]!.title,
                              taskCompleted: _guestTask[index]!.status,
                              onChanged: (value) => _toggleTodoStatus(index),
                              taskDetail: _guestTask[index]!.details,
                            ),
                            trailing: IconButton(
                              onPressed: () =>
                                  _deleteTodo(_guestTask[index]!.id),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
        ),
        //BODY ENDS HERE

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(19, 62, 135, 1),
          foregroundColor: Colors.white,
          hoverColor: Colors.white70,
          onPressed: _navigateToaddGuestTodo,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
