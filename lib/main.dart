import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nagarik_action_4thsemproject/landing_page.dart';
import 'package:nagarik_action_4thsemproject/screens/citizen/citizen_home_screen.dart';
import 'package:nagarik_action_4thsemproject/screens/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nagarik Action',

      theme: ThemeData(primarySwatch: Colors.orange),

      // Initial page (change later if needed)
      //  home: CitizenHomeScreen(),
      home: LandingPage(),
    );
  }
}
