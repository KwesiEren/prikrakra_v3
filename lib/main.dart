import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/login&signup/firstpage.dart';
import 'pages/login&signup/secondpage.dart';
import 'pages/statisticspage.dart';
import 'pages/survey.dart';
import 'pages/unauthed/guestview_page.dart';
import 'pages/welcomepage.dart';
import 'services/localdb_config/db_provider.dart';

// Okay so to get it out there I am not good at explaining
// stuff but I will try my best to give you clarity on the apps codes
// as best as I can to my knowledge.

//Code revisions can be made where possible because there is alot to improve
// in this project.

// I used Supabase client as my online database handler and I use sqflite as my
// local database handler.

Future<void> main() async {
  const uri = 'https://mfnwzlelhbcwriwgrjkc.supabase.co';
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1mbnd6bGVsaGJjd3Jpd2dyamtjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjgzODM3MzgsImV4cCI6MjA0Mzk1OTczOH0.AIF5MooVoQiqRoHsEjPksC5UtgHVx5_DblvqOLtjR1Y';
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: uri,
    anonKey: supabaseKey,
  );
  await AppDB.instance.mydatabase;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, routes: {
      //Navigation controls: just add pages class and label.
      '/': (context) => const WelcomeScreen(),
      '/guest': (context) => const GuestviewPage(),
      '/login': (context) => const LoginPage(),
      '/signup': (context) => const SignUp(),
      '/statistics': (context) => const StatisticsPage(),
      '/edwin': (context) => const SurveyPage(),
    });
  }
}
