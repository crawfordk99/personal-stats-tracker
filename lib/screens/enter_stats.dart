import 'package:flutter/material.dart';
import 'package:personal_stats_tracker/sports_stats.dart';
import 'package:personal_stats_tracker/services/firebase_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_stats_tracker/stats_notifier.dart';

class NumberInputScreen extends ConsumerStatefulWidget {
  const NumberInputScreen({super.key});
  @override
  NumberInputScreenState createState() => NumberInputScreenState();
}

class NumberInputScreenState extends ConsumerState<NumberInputScreen> {

  final FirebaseFirestoreService _firestore = FirebaseFirestoreService();
  // Set a list to hold calculatedStats
  Map<String, double> calculatedStats = {};

  @override
  Widget build(BuildContext context) {
    // Acts as a listener for changes, allows for not calling set state in a loop to implement
    // changes to the sport and menu
    final statsNotifier = ref.watch(statsProvider);

    //
    List<SportsStats> stats = sportsStats[statsNotifier] ?? [];

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
            // Allows for a drop down menu
            DropdownButton<String>(
                value: statsNotifier,
                onChanged: (newSport) {
                  // This way set state doesn't have to be called every time the user enters/presses
                  // something
                  ref.read(statsProvider.notifier).changeSport(newSport ?? "Basketball");
                },
                // Acesss the sports stats keys to return a drop menu of them
                items: sportsStats.keys.map((String sport) {
                  return DropdownMenuItem<String>(
                    value: sport,
                    child: Text(sport),
                  );
                }).toList(),
            ),
            const SizedBox(height: 20),

            // Dynamically render input fields
            Expanded(
                // Builds a "view" of the list of stats to ask the user to enter
                child: ListView.builder(
                    itemCount: stats.length,
                    itemBuilder: (context, index) {

                      // Access the specific stat inside the sport entry
                      SportsStats stat = stats[index];

                      // If the stat needs to be calculated, check if it already has been
                      // calculated. Return container prevents it from being asked as user input
                      if (stat.isCalculated) {
                        return Container(); // returns an empty widget, basically skips it and continues on with the list
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
                                  for (var s in stats) // loops through the stats, parsing the user input
                                    if (double.tryParse(s.controller.text) != null)
                                      // map the stat's name to the value
                                      s.name: double.parse(s.controller.text)
                                };
                                // Call the calculatedStats function along with the user's inputs
                                calculatedStats = calculateStats(statsNotifier, inputs);
                              });
                            },
                          )
                      );
                    }
                )
            ),
            ElevatedButton(
              onPressed: () async {

                // Create an empty dictionary to hold the userStats
                Map<String, dynamic> userStats = {};

                // loop through the list of stats
                for (var stat in sportsStats[statsNotifier] ?? []) {

                  // if the stat's user input isn't empty
                  if (stat.controller.text.isNotEmpty) {
                    // Add the user's inputs to the dictionary, key is the stats name
                    userStats[stat.name] = double.tryParse(stat.controller.text) ?? 0;
                  }
                }

                userStats.addAll(calculatedStats); // Add calculated stats


                try {
                  await _firestore.saveOrUpdateStats(statsNotifier, userStats);

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
          ],
        ),
      ),
    );
  } // widget
} // NumberInputScreenState
