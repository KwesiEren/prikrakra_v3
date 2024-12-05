import 'dart:async';

import 'package:flutter/material.dart';

import '../services/supabase_config/sb_auth.dart';
import '../theme_control.dart';
import 'authed/worksheet.dart';

//Welcome Screen, just that lol.

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Timer? _timer;
  final _auth = SBAuth();

  @override
  void initState() {
    // TODO: implement initState
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      _runPeriodicFunction();
      timer.cancel();
    });
    super.initState();
  }

  void _runPeriodicFunction() async {
    // Navigator.pushReplacementNamed(context, '/guest');
    await _initLoginStatus();
    debugPrint('Splash Screen');
  }

  Future<void> _initLoginStatus() async {
    final isLoggedIn = await _auth.isLoggedIn();
    if (isLoggedIn) {
      // Retrieve the logged-in user's email
      final email = await _auth.getLoggedInUserEmail();
      final userName = await _auth.getLoggedInUserName();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkArea(
            userEmail: email ?? '',
            userName: userName ?? '',
          ), // Pass email
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/guest');
    }
  }

  // Codes for the Splash Screen;
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screen.width,
        decoration:
            //Background Image here:
            const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/bg1.jpg'),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome!",
                    style: TextStyle(
                      color: ThemeCtrl.colors.color1,
                      fontSize: 50,
                    ),
                  ),
                  Text(
                    "Get started",
                    style: TextStyle(
                      color: ThemeCtrl.colors.color1,
                      fontSize: 30,
                    ),
                  )
                ],
              ),
            ),
            const Column(
              children: [
                Text(
                  'Version 2.5',
                  style: TextStyle(color: Color.fromARGB(99, 255, 255, 255)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
