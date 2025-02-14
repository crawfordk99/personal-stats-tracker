import 'package:flutter/material.dart';
import 'package:personal_stats_tracker/shooting_percentage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Stats Tracker',
      home: _NumberInputScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white60,
      ),
    );
  }
}
class _NumberInputScreen extends StatefulWidget {
  @override
  _NumberInputScreenState createState() => _NumberInputScreenState();
}

class _NumberInputScreenState extends State<_NumberInputScreen> {
  // Creates a variable to hold user input
  final TextEditingController _controller = TextEditingController();
  int? _fieldGoalsMade; // variable to store field goals made (fgm)
  int? _fieldGoalsAttempted; // variable to store field goals attempted (fga)
  double? _shootingPercentage; // variable to store result
  bool _isFGMEntered = false; // variable to make sure user already entered fgm

  // Function to convert input to number, and store it for calculations
  void _storeNumber() {
    setState(() {
      // Check to see if fgm has already been entered, otherwise enter fgm number
      if (!_isFGMEntered) {
        _fieldGoalsMade = int.tryParse(_controller.text);
        _isFGMEntered = true;
        _controller.clear(); // Allow for a second number to be entered
      } else {
        _fieldGoalsAttempted = int.tryParse(_controller.text);
        _isFGMEntered = false; // reset to allow for new calculation
        _controller.clear();
      }
    });
  }
  // runs before the build, and helps recall what shooting percentage was last time it ran
  @override
  void initState() {
    super.initState();
    _loadPercentage();
  }

  // A basic form of saving data in dart, shared preferences can handle saving small bits of data
  Future<void> _loadPercentage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _shootingPercentage = prefs.getDouble('shooting_percentage') ?? 0;
    });
  }

  /* This will connect the shooting percentage class. This helps keep the code cleaner,
  * and lets a different class other than main worry about the calculations*/
  Future<void> _calculatePercentage() async {
    final prefs = await SharedPreferences.getInstance();
    double result = 0.0;
    if (_fieldGoalsMade != null && _fieldGoalsAttempted != null) {
      result = ShootingPercentage.calculateShootingPercentage(_fieldGoalsMade ?? 0, _fieldGoalsAttempted ?? 0);
      prefs.setDouble('shooting_percentage', result);
      setState(() {
        _shootingPercentage = result;
      });
      // _savePercentage(_shootingPercentage ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Builds every time set state is called
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Stats Tracker'),
        backgroundColor: Colors.white60,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // Align button in the center of the screen
          mainAxisAlignment: MainAxisAlignment.center,
          // control the button widget, and the text
          children: <Widget>[
            TextField(
              // Saves user input
              controller: _controller,
              // Allows for enter key strokes to be recognized
              autofocus: true,
              // Focus on numbers being entered
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                // Affects text for user input
                labelText: _isFGMEntered ? 'Field Goals Attempted' : 'Field Goals Made',
                // Puts a border around the user input text box
                border: OutlineInputBorder(),
              ),
              // Allow for pressing enter to submit number
              onSubmitted: (value){
                _storeNumber();
            },
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: _storeNumber,
                child: Text(_isFGMEntered ? 'Enter Field Goals Attempted' : 'Enter Field Goals Made'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: _calculatePercentage,
                child: Text('Calculate Shooting Percentage'),
            ),
            Text(
              // Confirm number is stored, or if nil, tell user it wasn't stored
              _fieldGoalsMade != null ? 'Field Goals Made: $_fieldGoalsMade' : '',
              style: TextStyle(fontSize: 12, fontFamily: "Times New Roman"),
            ),
            Text(
              _fieldGoalsAttempted != null ? 'Field Goals Attempted: $_fieldGoalsAttempted' : '',
              style: TextStyle(fontSize: 12, fontFamily: "Times New Roman"),
            ),
            Text(
              _shootingPercentage != null ? 'Shooting Percentage: ${((_shootingPercentage ?? 0) * 100).toStringAsFixed(2)}%' : '',
              style: TextStyle(fontSize: 20, fontFamily: "Arial", fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  } // widget
  // Future<void> _savePercentage(double percentage) async{
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setDouble('shooting_percentage', percentage);
  // }
} // NumberInputScreenState

