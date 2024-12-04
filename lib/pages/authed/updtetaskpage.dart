import 'package:flutter/material.dart';

import '../../components/button.dart';
import '../../models/task.dart';
import '../../models/task_type.dart';
import '../../services/localdb_config/db_provider.dart';
import '../../services/supabase_config/sb_db.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo? todo;
  final Function(Todo) onTodoUpdated;

  const EditTodoScreen({
    Key? key,
    required this.todo,
    required this.onTodoUpdated,
  }) : super(key: key);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

//This codes below hold logic for the edit task page.

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _details;
  late TaskType _taskType;
  bool _status = false;

  @override
  void initState() {
    super.initState();
    _title = widget.todo!.title;
    _details = widget.todo!.details;
    _taskType = widget.todo!.taskType;
    _status = widget.todo!.status;
  }

  // Functions to update the task in the online database
  void updtetoSB(Todo todo) async {
    if (todo.id == null) {
      throw Exception('Todo ID cannot be null');
    }

    await SupaDB.updateSB(todo);
  }

  // Function to handle all update request for local and online database
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updatedTodo = widget.todo!.copyWith(
        title: _title,
        details: _details,
        taskType: _taskType,
        status: _status,
      );

      await SupaDB.updateSB(updatedTodo);

      await AppDB.instance.updateTodo(updatedTodo);
      widget.onTodoUpdated(updatedTodo);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todo updated successfully!')),
      );
      Navigator.pop(context);
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
              DropdownButtonFormField<TaskType>(
                decoration: const InputDecoration(labelText: 'Task Type'),
                value: _taskType,
                onChanged: (value) {
                  setState(() {
                    _taskType = value!;
                  });
                },
                items: TaskType.values.map((TaskType type) {
                  return DropdownMenuItem<TaskType>(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
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
              GestureDetector(
                  onTap: _submitForm,
                  child: ButnTyp1(
                      text: 'Save Changes',
                      size: 20,
                      btnColor: const Color.fromRGBO(19, 62, 135, 1),
                      borderRadius: 5))
            ],
          ),
        ),
      ),
    );
  }
}
