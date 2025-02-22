import 'package:personal_stats_tracker/services/firebase_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_stats_tracker/sports_stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_stats_tracker/stats_notifier.dart';

class SeeStats extends ConsumerStatefulWidget {
  const SeeStats({super.key});

  @override
  SeeStatsState createState() => SeeStatsState();
}

class SeeStatsState extends ConsumerState<SeeStats> {
  final FirebaseFirestoreService _firestore = FirebaseFirestoreService();


  
  @override
  Widget build(BuildContext context) {

    // Acts a listener for changes in selected sport
    final statsNotifier = ref.watch(statsProvider);
    List<SportsStats> stats = sportsStats[statsNotifier] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("User Stats Report"),
        backgroundColor: Colors.white60,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: statsNotifier,
              onChanged: (newSport) {
                // reads change in selected sport, otherwise defaults to basketball
                ref.read(statsProvider.notifier).changeSport(newSport ?? "Basketball");
              },
              // check the sportsStats dictionaries keys for the different sports options
              items: sportsStats.keys.map((String sport) {
                return DropdownMenuItem<String>(
                  value: sport,
                  child: Text(sport),
                );
              }).toList(),
            ),
            Expanded(
                // Get user stats
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.getStatsStream(statsNotifier),
                  builder: (context, snapshot) {
                    // if snapshot doesn't have data, indicate with buffer circle
                    if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                    }

                    // access the stats in the docs if data exists
                    var statsList = snapshot.data?.docs;

                    return ListView.builder(
                      itemCount: statsList?.length,
                      itemBuilder: (context, index) {

                        var data = statsList?[index].data() as Map<String, dynamic>;
                        var statId = statsList?[index].id;  // Get the document ID to allow for deletion

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            // Displays stats in order of time
                            title: Text("${data['timestamp']?.toDate()}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data.entries.map((entry) {
                                if (entry.key != "timestamp") {
                                  return Text("${entry.key}: ${entry.value}");
                                }
                                return Container();
                              }).toList(),

                            ),
                            // This allows for button to accompany the entry of stats.
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                try {
                                  // Pass the sport name, and the stat id to delete the specific stat entry
                                  await _firestore.deleteUserStats(statsNotifier, statId);
                                }
                                catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Error deleting stat: $e"))
                                      );
                                }
                              }
                            ),
                          ),

                        );

                      },
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );

  }
}