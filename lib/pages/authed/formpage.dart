import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/task.dart';
import '../../models/task_type.dart';

// This the codes which handle the logics on  the add todo page
class AddTodoScreen extends StatefulWidget {
  final String userName;
  final Function(Todo) onTodoAdded;

  const AddTodoScreen(
      {super.key, required this.userName, required this.onTodoAdded});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String? _details;
  TaskType _taskType = TaskType.today;
  String _user = '';
  String? _team;
  bool _status = false;
  bool _isSynced = false;

  // Function to add the new task to the online DB
  Future<void> addTaskSB(Todo todo) async {
    try {
      await Supabase.instance.client.from('todoTable').insert(todo.toJson());
    } catch (error) {
      _showToast('Error adding Todo');
      print('Error adding task: $error');
    }
  }

  // Function to show a toast message
  void _showToast(String message) {
    showToast(
      message,
      context: context,
      backgroundColor: const Color.fromRGBO(19, 62, 135, 1),
    );
  }

  // Function to clear form fields
  void _clearForm() {
    _title = '';
    _details = '';
    _user = '';
    _team = '';
    setState(() {});
  }

  // Function to handle the form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Set the user to default username if the field is empty
      if (_user.isEmpty) {
        _user = widget.userName;
      }

      final uuid = Uuid(); // Generate a new UUID for the task ID
      final newTodo = Todo(
        id: uuid.v4(),
        title: _title,
        details: _details,
        user: _user,
        team: _team,
        taskType: _taskType,
        crtedDate: DateTime.now(),
        status: _status,
        isSynced: _isSynced,
      );

      // Add task to Supabase and handle completion
      await addTaskSB(newTodo);

      // Show a success toast
      _showToast('Todo added successfully');

      // Call the callback and pop the screen
      widget.onTodoAdded(newTodo);
      Navigator.pop(context);

      // Clear the form after submission
      _clearForm();
    }
  }

  // UI code block here:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(19, 62, 135, 1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              const SizedBox(height: 5),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Details'),
                maxLines: 4,
                onSaved: (value) {
                  _details = value;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<TaskType>(
                value: _taskType,
                decoration: const InputDecoration(labelText: 'Task Type'),
                items: TaskType.values.map((taskType) {
                  return DropdownMenuItem<TaskType>(
                    value: taskType,
                    child: Text(taskType.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _taskType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'User',
                  hintText: widget.userName,
                ),
                onSaved: (value) {
                  _user = widget.userName;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Team'),
                onSaved: (value) {
                  _team = value;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
