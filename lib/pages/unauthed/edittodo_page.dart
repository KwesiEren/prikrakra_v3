import 'package:flutter/material.dart';

import '../../components/button.dart';
import '../../models/gtask.dart';
import '../../theme_control.dart';
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
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
        centerTitle: true,
        backgroundColor: ThemeCtrl.colors.color1,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: screen.width,
        decoration:
            //Background Image block:
            BoxDecoration(color: ThemeCtrl.colors.colorbg
                // image: DecorationImage(
                //     fit: BoxFit.cover, image: AssetImage('assets/bg3.jpg')),
                ),
        child: Padding(
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
                GestureDetector(
                    onTap: _submitForm,
                    child: ButnTyp1(
                        text: 'Save Changes',
                        size: 20,
                        btnColor: ThemeCtrl.colors.color1,
                        borderRadius: 5))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
