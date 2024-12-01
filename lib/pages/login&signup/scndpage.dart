import 'package:flutter/material.dart';

import '../../components/button.dart';
import '../../components/glscontainer.dart';
import '../../components/textarea.dart';
import '../../services/supabase_config/sb_auth.dart';
import '../authed/worksheet.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

//This is the codes block for the signup page and has user auth added.

class _SignUpState extends State<SignUp> {
  late final TextEditingController _userinput = TextEditingController();
  late final TextEditingController _emailinput = TextEditingController();
  late final TextEditingController _passwrdinput = TextEditingController();
  final _auth = SBAuth();

  //Sign up function which adds users to online database
  Future<void> signup() async {
    final username = _userinput.text;
    final email = _emailinput.text;
    final password = _passwrdinput.text;

    await _auth.signUp(username, email, password);

    _onSignupSuccess(username, email, password);
  }

  void _onSignupSuccess(String username, String email, String password) {
    _userinput.clear();
    _emailinput.clear();
    _passwrdinput.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkArea(
          userEmail: email,
          userName: username,
        ), // Pass email
      ),
    );
  }

  //UI code for Signup page here:
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screen.width,
          height: screen.height,
          decoration:
              //Background image here:
              const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg4.jpeg'), fit: BoxFit.cover)),
          child: SafeArea(
            child: Container(
              width: screen.width,
              height: screen.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(19, 62, 135, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GlassBox(
                    height: screen.height * 0.00085,
                    child: Container(
                      padding: const EdgeInsets.only(left: 45, right: 45),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          RichText(
                            text: const TextSpan(
                              text:
                                  'Looks like you don\'t have an Account.\nLet\'s create one for now and ',
                              style: TextStyle(
                                color: Color.fromRGBO(96, 139, 193, 1),
                              ), // General text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'join our Community.', // Word 'there'
                                  style: TextStyle(
                                      color: Color.fromRGBO(96, 139, 193, 1),
                                      fontWeight: FontWeight
                                          .w700), // 'there' in blue color
                                ),
                                TextSpan(
                                  text: '.', // Text after 'there'
                                  style: TextStyle(
                                      color:
                                          Colors.black), // General text style
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InputField(
                                displaytxt: 'Username',
                                hidetxt: false,
                                borderRadius: 20,
                                contrlr: _userinput,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InputField(
                                displaytxt: 'Email',
                                hidetxt: false,
                                borderRadius: 20,
                                contrlr: _emailinput,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InputField(
                                displaytxt: 'Password',
                                hidetxt: true,
                                borderRadius: 20,
                                contrlr: _passwrdinput,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              signup();
                              //Navigator.pushNamed(context, '/todo_scrn');
                            },
                            child: ButnTyp1(
                              text: 'SignUp',
                              size: 20,
                              btnColor: const Color.fromRGBO(19, 62, 135, 1),
                              borderRadius: 5,
                            ),
                          ),
                          const Text(
                            'or',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Color.fromRGBO(96, 139, 193, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Do you have an account? ',
                                style: TextStyle(
                                  color: Color.fromRGBO(96, 139, 193, 1),
                                  fontSize: 15,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      decorationColor:
                                          Color.fromRGBO(96, 139, 193, 1),
                                      color: Color.fromRGBO(96, 139, 193, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
