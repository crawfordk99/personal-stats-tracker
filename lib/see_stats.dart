import 'package:personal_stats_tracker/services/firebase_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_stats_tracker/sports_stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeeStats extends StatefulWidget {
  const SeeStats({super.key});

  @override
  SeeStatsState createState() => SeeStatsState();
}

class SeeStatsState extends State<SeeStats> {
  final FirebaseFirestoreService _firestore = FirebaseFirestoreService();

  String selectedSport = "basketball";
  
  @override
  Widget build(BuildContext context) {
    List<SportsStats> stats = sportsStats[selectedSport] ?? [];
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
              value: selectedSport,
              items: sportsStats.keys.map((String sport) {
                return DropdownMenuItem<String>(
                  value: sport,
                  child: Text(sport),
                );
              }).toList(),
              onChanged: (newSport) {
                setState(() {
                  selectedSport = newSport ?? "Basketball";
                });
              },
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.getStatsStream(selectedSport),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                    }


                    var statsList = snapshot.data?.docs;

                    return ListView.builder(
                      itemCount: statsList?.length,
                      itemBuilder: (context, index) {

                        var data = statsList?[index].data() as Map<String, dynamic>;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
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
                          ),
                        );
                      },
                    );
                  },
                ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/enterStats');
              },
              child: Text("Enter Stats"),
            ),
          ],
        ),
      ),
    );

  }
}