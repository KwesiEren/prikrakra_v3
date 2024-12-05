import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:prikrakra_v3/components/button.dart';
import 'package:prikrakra_v3/services/localdb_config/db_provider.dart';
import 'package:prikrakra_v3/utils/security_scheme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme_control.dart';
import '../utils/shared_preferences_helper.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final crypt = PasswordHandler();
  String? _username;
  String? _email;
  String? _password;
  String? _cpassword;
  String? catchUsr;
  var tempContainer = '';
  String? savUsr;

// Function to show a toast message
  void _showToast(String message) {
    showToast(
      message,
      context: context,
      backgroundColor: ThemeCtrl.colors.color1,
    );
  }

  // Function to clear form fields
  void _clearForm() {
    _username = '';
    _email = '';
    _password = '';
    setState(() {});
  }

  // Function to handle the form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get username to SharedPreferences
      catchUsr = await SharedPreferencesHelper.getUsername();

      //Encode Password;
      final enrypPassword = crypt.encode(_password!);

      setState(() {
        tempContainer = catchUsr!;
      });

      await Supabase.instance.client.from('user_credentials').update({
        'user': _username,
        'password': enrypPassword,
        'email': _email
      }).eq('user', tempContainer);

      // Show a success toast
      _showToast('Details updated successfully');

      // Store new username and email
      await SharedPreferencesHelper.saveUsername(_username!);
      await SharedPreferencesHelper.saveUserEmail(_email!);
      // Update username in tasks
      await AppDB.instance.updateUsernameForTasks(tempContainer, _username!);

      // Call the callback and pop the screen
      Navigator.pop(
        context,
      );

      // Clear the form after submission
      _clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details'),
        centerTitle: true,
        backgroundColor: ThemeCtrl.colors.color1,
        foregroundColor: ThemeCtrl.colors.colorw,
      ),
      body: SafeArea(
          child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: screen.width,
          decoration:
              //Background Image block:
              BoxDecoration(color: ThemeCtrl.colors.colorbg),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: screen.width * 0.9,
                          height: 50,
                          decoration:
                              //Background Image block:
                              BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'JohnDoe',
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(103, 0, 0, 0))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username will remain unchanged if empty';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _username = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 50,
                          decoration:
                              //Background Image block:
                              BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'JohnDoe@gmail.com',
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(103, 0, 0, 0))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email will remain unchanged if empty';
                                }
                                if (!RegExp(
                                        r'^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid Email address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _email = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Password: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 50,
                          decoration:
                              //Background Image block:
                              BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: const Color.fromARGB(255, 2, 2, 2),
                                      width: 1),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextFormField(
                              obscureText: true,
                              obscuringCharacter: '*',
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '*********',
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(103, 0, 0, 0))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password will remain unchanged if empty';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _password = value!;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          ' Confirm Password: ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 50,
                          decoration:
                              //Background Image block:
                              BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: const Color.fromARGB(255, 2, 2, 2),
                                      width: 1),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: TextFormField(
                              obscureText: true,
                              obscuringCharacter: '*',
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '*********',
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(103, 0, 0, 0))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password will remain unchanged if empty';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long.';
                                }
                                if (value != _password) {
                                  return 'Password does not match!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _cpassword = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                      onTap: _submitForm,
                      child: ButnTyp1(
                          text: 'Update Details',
                          size: 15,
                          btnColor: ThemeCtrl.colors.color1,
                          borderRadius: 5))
                  //  ElevatedButton(
                  //   style: ButtonStyle(
                  //     backgroundColor: ,
                  //   ),
                  //   onPressed: _submitForm,
                  //   child: Text('Update Details'),
                  // ),
                ],
              )),
        ),
      )),
    );
  }
}
