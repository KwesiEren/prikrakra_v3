import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:uuid/uuid.dart';

import '../../models/gtask.dart';
import '../../utils/shared_preferences_helper.dart';

class AddGuestTodoScreen extends StatefulWidget {
  const AddGuestTodoScreen({
    super.key,
  });

  @override
  _AddGuestTodoScreenState createState() => _AddGuestTodoScreenState();
}

class _AddGuestTodoScreenState extends State<AddGuestTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String? _details;
  bool _status = false;

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
    setState(() {});
  }

  // Function to handle the form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final uuid = Uuid(); // Generate a new UUID for the task ID
      final newTodo = Task(
        id: uuid.v4(),
        title: _title,
        details: _details,
        status: _status,
      );

      // Add the new todo to SharedPreferences
      await SharedPreferencesHelper.addTodo(newTodo);

      // Show a success toast
      _showToast('Todo added successfully');

      // Call the callback and pop the screen
      Navigator.pop(context, newTodo);

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
