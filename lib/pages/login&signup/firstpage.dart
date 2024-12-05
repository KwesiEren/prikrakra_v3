import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/button.dart';
import '../../components/glscontainer.dart';
import '../../components/textarea.dart';
import '../../components/tile.dart';
import '../../services/supabase_config/sb_auth.dart';
import '../authed/worksheet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// This is the Codes for the Login page. I have integrated  user
// authentication using email and password. NB: You can only login when online.

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();
  final _auth = SBAuth();

  @override
  void initState() {
    // TODO: implement initState
    _checkLoginStatus();
    super.initState();
  }

  @override
  void dispose() {
    _emailInput.dispose();
    _passwordInput.dispose();
    super.dispose();
  }

  // Function to show a toast message
  Future<void> _showToast(String message) async {
    showToast(
      message,
      context: context,
      backgroundColor: const Color.fromARGB(255, 59, 99, 168),
    );
  }

  Future<void> _checkLoginStatus() async {
    final isLoggedIn = await _auth.isLoggedIn();
    if (isLoggedIn) {
      // Retrieve the logged-in user's email
      final user = await _auth.getLoggedInUserName();
      final email = await _auth.getLoggedInUserEmail();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkArea(
            userEmail: email ?? '',
            userName: user ?? '',
          ), // Pass email
        ),
      );
    } else {
      debugPrint('No User Session Found, Log in again.');
    }
  }

  // Login Function that takes the email and password as parameters
  // and runs an authentication call to the online database.
  Future<void> loginAct() async {
    final email = _emailInput.text;
    final password = _passwordInput.text;

    if (!RegExp(
            r'^[a-zA-Z0-9]+([._]?[a-zA-Z0-9]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z]{2,})+$')
        .hasMatch(email)) {
      return _showToast('Enter a valid Email address');
    }

    if (password.length < 8) {
      return _showToast('Password must be at least 8 characters long.');
    }

    final response = await _auth.login(email, password);
    final username = await Supabase.instance.client
        .from('user_credentials')
        .select('user')
        .eq('email', email)
        .single();
    final catchUser = username['user'];

    if (response.startsWith("Login successful")) {
      await _showToast("Login successful");
      _onLoginSuccess(email, catchUser);
      return;
    }

    if (response.startsWith('Login failed: Incorrect Credentials')) {
      await _showToast("Incorrect Password");
      return;
    }

    if (response.startsWith('Try Again please')) {
      await _showToast("Incorrect Email");
      return;
    }
  }

  void _onLoginSuccess(String email, catchUser) {
    _emailInput.clear(); // Clear email input
    _passwordInput.clear(); // Clear password input
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkArea(
          userEmail: email,
          userName: catchUser,
        ), // Pass email
      ),
    );
  }

  // UI code block:
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screen.width,
          height: screen.height,
          decoration:
              //Background Image here:
              const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg4.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  // color: Colors.red,
                  width: screen.width,
                  height: screen.height * 0.2,
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Color.fromRGBO(19, 62, 135, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GlassBox(
                      // height: screen.height * 0.00055,
                      child: Container(
                        padding: const EdgeInsets.only(left: 45, right: 45),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InputField(
                                  displaytxt: 'Email',
                                  hidetxt: false,
                                  borderRadius: 20,
                                  contrlr: _emailInput,
                                ),
                                const SizedBox(height: 20),
                                InputField(
                                  displaytxt: 'Password',
                                  hidetxt: true,
                                  borderRadius: 20,
                                  contrlr: _passwordInput,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: loginAct,
                              child: ButnTyp1(
                                text: 'LOGIN',
                                size: 15,
                                btnColor: const Color.fromRGBO(19, 62, 135, 1),
                                borderRadius: 5,
                              ),
                            ),
                            const Text(
                              'or',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                                color: Color.fromRGBO(96, 139, 193, 1),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: screen.width * 0.18,
                                      height: screen.height * 0.08,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            228, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image:
                                                AssetImage('assets/google.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: ButnTile(
                                      icnName: 'assets/twitter.png',
                                      margin: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account? ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(96, 139, 193, 1),
                                    fontSize: 15,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor:
                                          Color.fromRGBO(96, 139, 193, 1),
                                      color: Color.fromRGBO(96, 139, 193, 1),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromRGBO(96, 139, 193, 1),
                                  color: Color.fromRGBO(96, 139, 193, 1),
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
