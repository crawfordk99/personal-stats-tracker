import 'package:flutter/material.dart';
import 'enter_stats.dart';
import 'see_stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Sets up navigation bar options
  final List<Widget> _screens = [
    NumberInputScreen(),
    SeeStats(),
  ];

  // switches the index of the list of screens on tap of screen icon
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Switch between screens
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Enter Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'See Stats'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}