import 'package:flutter/material.dart';

import '../../models/gtask.dart';
import '../../utils/shared_preferences_helper.dart';

class EditGuestTodoScreen extends StatefulWidget {
  final Task? todo;
  final Function(Task) onTodoUpdated;

  const EditGuestTodoScreen({
    Key? key,
    required this.todo,
    required this.onTodoUpdated,
  }) : super(key: key);

  @override
  _EditGuestTodoScreenState createState() => _EditGuestTodoScreenState();
}

//This codes below hold the edit task page. that is just how to put it straight

class _EditGuestTodoScreenState extends State<EditGuestTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _details;
  bool _status = false;

  @override
  void initState() {
    super.initState();
    _title = widget.todo!.title;
    _details = widget.todo!.details;
    _status = widget.todo!.status;
  }

  // void updateExistingTodo() async {
  //   // Create an updated todo object (with the same id as the existing one)
  //   Task updatedTodo = Task(
  //     id: widget.todo!.id,
  //     title: widget.todo!.title,
  //     details: widget.todo!.details,
  //     status: widget.todo!.status,
  //   );
  //
  //   // Call the update method
  //   await SharedPreferencesHelper.updateTodo(updatedTodo);
  //
  //   // Optional: Retrieve the updated list to verify changes
  //   List<Task> todos = await SharedPreferencesHelper.getTodoList();
  //   todos.forEach((todo) {
  //     print('${todo.id}: ${todo.title} - ${todo.details}');
  //   });
  //
  //   debugPrint('done with update');
  //
  //   widget.onTodoUpdated(updatedTodo);
  // }

  // Function to handle all update request for local and online database
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Task updatedTodo = Task(
        id: widget.todo!.id,
        title: _title,
        details: _details,
        status: _status,
      );

      await SharedPreferencesHelper.updateTodo(updatedTodo);

      // Notify parent widget
      widget.onTodoUpdated(updatedTodo);

      Navigator.pop(context, updatedTodo);
    }
  }

  //UI codes here:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(19, 62, 135, 1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value!,
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              TextFormField(
                initialValue: _details,
                decoration: const InputDecoration(labelText: 'Details'),
                onSaved: (value) => _details = value,
              ),
              SwitchListTile(
                title: const Text('Status'),
                value: _status,
                onChanged: (value) {
                  setState(() {
                    _status = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text('Update Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
