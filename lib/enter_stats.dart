import 'package:flutter/material.dart';
import 'package:personal_stats_tracker/sports_stats.dart';
import 'package:personal_stats_tracker/services/firebase_firestore.dart';


class NumberInputScreen extends StatefulWidget {
  const NumberInputScreen({super.key});
  @override
  NumberInputScreenState createState() => NumberInputScreenState();
}

class NumberInputScreenState extends State<NumberInputScreen> {
  // default sport
  String selectedSport = "Basketball";
  final FirebaseFirestoreService _firestore = FirebaseFirestoreService();
  // Set a list to hold calculatedStats
  Map<String, double> calculatedStats = {};

  @override
  Widget build(BuildContext context) {
    List<SportsStats> stats = sportsStats[selectedSport] ?? [];
    // Builds every time set state is called
    print("Building");
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
            DropdownButton<String>(
                value: selectedSport,
                items: sportsStats.keys.map((String sport) {
                  return DropdownMenuItem<String>(
                      value: sport,
                      child: Text(sport)
                  );
                }).toList(),
                onChanged: (newSport) {
                  setState(() {
                    selectedSport = newSport ?? "Basketball";
                    calculatedStats.clear();
                    for (var stat in sportsStats[selectedSport] ?? []) {
                      stat.controller.clear();
                    }
                  });
                }
            ),
            const SizedBox(height: 20),

            // Dynamically render input fields
            Expanded(
                child: ListView.builder(
                    itemCount: stats.length,
                    itemBuilder: (context, index) {
                      SportsStats stat = stats[index];

                      if (stat.isCalculated) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "${stat.name}: ${calculatedStats[stat.name]?.toStringAsFixed(2) ?? '0.00'}%",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        );
                      }

                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: stat.controller,
                            decoration: InputDecoration(
                              labelText: stat.name,
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                Map<String, double> inputs = {
                                  for (var s in stats)
                                    if (!s.isCalculated && double.tryParse(s.controller.text) != null)
                                      s.name: double.parse(s.controller.text)
                                };
                                calculatedStats = calculateStats(selectedSport, inputs);
                              });
                            },
                          )
                      );
                    }
                )
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> userStats = {};

                for (var stat in sportsStats[selectedSport] ?? []) {
                  if (!stat.isCalculated && stat.controller.text.isNotEmpty) {
                    userStats[stat.name] = double.tryParse(stat.controller.text) ?? 0;
                  }
                }

                userStats.addAll(calculatedStats); // Add calculated stats

                try {
                  await _firestore.saveStats(selectedSport, userStats);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Stats saved successfully!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error saving stats: $e")),
                  );
                }
              },
              child: Text("Save Stats"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/seeStats');
              },
              child: Text("View Stats"),
            ),
          ],
        ),
      ),
    );
  } // widget
} // NumberInputScreenState
