import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:personal_stats_tracker/enter_stats.dart';
import 'package:personal_stats_tracker/see_stats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();

    runApp(MyApp());
  } catch (e) {
    print("Firebase failed to initialize: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Stats Tracker',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white60,
      ),
      initialRoute: '/enterStats',
      routes: {
        '/enterStats': (context) => NumberInputScreen(),
        '/seeStats': (context) => SeeStats(),
      },
    );
  }
}

