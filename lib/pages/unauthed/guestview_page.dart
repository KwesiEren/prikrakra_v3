import 'dart:io';
import 'addtodo_page.dart';
import 'edittodo_page.dart';
import '../../models/gtask.dart';
import '../../theme_control.dart';
import 'package:flutter/material.dart';
import '../../components/button2.dart';
import '../../components/button3.dart';
import '../../components/guestview_list.dart';
import '../../utils/shared_preferences_helper.dart';

class GuestviewPage extends StatefulWidget {
  const GuestviewPage({super.key});

  @override
  State<GuestviewPage> createState() => _GuestviewPageState();
}

class _GuestviewPageState extends State<GuestviewPage> {
  List<Task?> _guestTask = [];
  DateTime? _lastPressedAt;
  bool isLoading = true;

  @override
  void initState() {
    _loadTodos(); // Load todos when the screen initializes
    super.initState();
  }

  Future<void> _opensession() async {
    Navigator.pushNamed(context, '/login');
  }

  // Method to fetch todos from SharedPreferences
  Future<void> _loadTodos() async {
    List<Task> todos = await SharedPreferencesHelper.getTodoList();
    setState(() {
      _guestTask = todos;
      isLoading = false;
    });
  }

  void _toggleTodoStatus(int index) async {
    // Fetch the current list of todos
    List<Task> todos = await SharedPreferencesHelper.getTodoList();

    // Get the selected task
    Task task = todos[index];

    // Toggle the status
    bool newStatus = !task.status;

    // Update the status in SharedPreferences
    await SharedPreferencesHelper.updateTodoStatus(task.id, newStatus);

    setState(() {
      _loadTodos();
    });
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
          backgroundColor: ThemeCtrl.colors.color1,
          foregroundColor: ThemeCtrl.colors.colorw,
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
                        backgroundColor: Color.fromRGBO(96, 139, 193, 100),
                        radius: 85,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/bg2.jpg'),
                          radius: 80,
                        ),
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
                // const SizedBox(
                //   height: 50,
                // ),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/statistics');
                          },
                          title: ButnTyp2(
                              text: 'Statistics',
                              size: 20,
                              btnColor: ThemeCtrl.colors.color1,
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
                              btnColor: ThemeCtrl.colors.color1,
                              borderRadius: 5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screen.height * 0.25,
                    ),
                    ListTile(
                      onTap: () {
                        _opensession();
                      },
                      title: ButnTyp3(
                          text: 'Log in',
                          size: 20,
                          btnColor: ThemeCtrl.colors.colorbtn1,
                          borderRadius: 5),
                    ),
                  ],
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
                BoxDecoration(color: ThemeCtrl.colors.colorbg),
            child: Center(
              child: RefreshIndicator(
                onRefresh: _loadTodos,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _guestTask.isEmpty
                        ? Text(
                            'The list is empty!',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: ThemeCtrl.colors.color3,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _guestTask.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, index) {
                              return Card(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10),
                                child: GestureDetector(
                                  onLongPress: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditGuestTodoScreen(
                                          todo: _guestTask[index],
                                          onTodoUpdated: (updatedTodo) {
                                            setState(() {
                                              // Update the todo in the local UI list
                                              final index = _guestTask
                                                  .indexWhere((todo) =>
                                                      todo!.id ==
                                                      updatedTodo.id);
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
                                        color: ThemeCtrl.colors.color3,
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
                                        taskCompleted:
                                            _guestTask[index]!.status,
                                        onChanged: (value) =>
                                            _toggleTodoStatus(index),
                                        taskDetail: _guestTask[index]!.details,
                                      ),
                                      trailing: IconButton(
                                        onPressed: () =>
                                            _deleteTodo(_guestTask[index]!.id),
                                        icon: Icon(
                                          Icons.delete,
                                          color: ThemeCtrl.colors.colorbtn1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
              ),
            ),
          ),
        ),
        //BODY ENDS HERE

        floatingActionButton: FloatingActionButton(
          backgroundColor: ThemeCtrl.colors.color1,
          foregroundColor: Colors.white,
          hoverColor: Colors.white70,
          onPressed: _navigateToaddGuestTodo,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
