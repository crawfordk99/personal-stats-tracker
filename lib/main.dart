import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_stats_tracker/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_stats_tracker/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_stats_tracker/services/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseAuthService _authService = FirebaseAuthService();

void main() async {

  // Call before initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();


  // best practice to throw Firebase functions with a try catch statement to prevent
  // crashes if unable to connect to firebase emulators
  try {
    await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: 'key',
      appId: 'id',
      messagingSenderId: 'sendid',
      projectId: 'myapp',
      storageBucket: 'myapp-b9yt18.appspot.com',
    ));

    // Connect the firestore and auth emulators to the same host as flutter
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    // Allows for use of flutter riverpod, and for listeners
    runApp(const ProviderScope(child: MyApp()));
  }
  catch (e) {
    print("Error with initializing Firebase: $e");
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
      home: StreamBuilder<User?>(
        stream: _authService.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();  // While Firebase is loading
          }

          // If the user is logged in, show the HomeScreen
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            // If the user is not logged in, show the LoginPage
            return LoginPage();
          }
        },
      ),
    );
  }
}

