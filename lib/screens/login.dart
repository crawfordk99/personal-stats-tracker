import 'package:flutter/material.dart';
import 'package:personal_stats_tracker/screens/home_screen.dart';
import 'package:personal_stats_tracker/services/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _authService = FirebaseAuthService();

  // Hold the email and password input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Determines whether to show signup or login form
  bool _isSignUpMode = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService.connectAuthEmulator(); // Optional: Connect to emulator
  }

  // Toggles whether to be in sign up mode or not
  _toggleAuthMode() {
    setState(() {
      _isSignUpMode = !_isSignUpMode;
    });
  }

  // Authenticates user email/password, and calls either sign up or login function
  _authenticate() async {
    setState(() {
      _isLoading = true;
    });

    if (_isSignUpMode) {
      await _signUp();
    } else {
      await _logIn();
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Handles sign up form
  Future<void> _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await _authService.signUp(email, password);
    if (user != null) {
      // Successfully signed up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Show an error message
      _showErrorMessage("Sign-up failed");
    }
  }

  // Handles login form
  Future<void> _logIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await _authService.logIn(email, password);

    // User must already be signed up, and email/password must match, otherwise this if statement
    // will fail
    if (user != null) {
      // Successfully logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Show an error message
      _showErrorMessage("Log-in failed");
    }
  }

  _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUpMode ? "Sign Up" : "Log In")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email form
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress, // focus on email text format
            ),
            // Password form
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true, // hides text since it's a password
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator() // Buffer circle to show authentication is happening
                // Sign up/ Log in button
                : ElevatedButton(
              onPressed: _authenticate,
              child: Text(_isSignUpMode ? 'Sign Up' : 'Log In'),
            ),
            // Switches the log in / sign up mode. The text itself is a button, without any layering
            TextButton(
              onPressed: _toggleAuthMode,
              child: Text(
                _isSignUpMode ? 'Already have an account? Log In' : 'Don’t have an account? Sign Up',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

