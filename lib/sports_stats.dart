/* This class will handle calculations for shooting percentages*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SportsStats {
  String name;

  // Allows for each stat to have its own input holder
  TextEditingController controller;

  // For stats that need to be calculated, doesn't calculate until this is true
  bool isCalculated;

  // the brackets allow for optionality, every stat must have a name though, and comes along with a controller
  // to take user input on it
  SportsStats(this.name, {this.isCalculated = false})
    : controller = TextEditingController();
}

// The individual sports act as the key, with a value as a list of stats
Map<String, List<SportsStats>> sportsStats = {
  "Basketball": [
    SportsStats("2pt Field Goals Made"),
    SportsStats("2pt Field Goals Attempted"),
    SportsStats("3pt Field Goals Made"),
    SportsStats("3pt Field Goals Attempted"),
    SportsStats("Assists"),
    SportsStats("Rebounds"),
    SportsStats("Turnovers"),
    SportsStats("True Shooting Percentage", isCalculated: true), // needs calculation
    SportsStats("Pure Point Percentage", isCalculated: true) // needs calculation
  ],
  "Baseball": [
    SportsStats("Hits"),
    SportsStats("At Bats"),
    SportsStats("Pitcher Strikeouts"),
    SportsStats("Batters Faced"),
    SportsStats("Batting Average", isCalculated: true), // needs calculation
    SportsStats("Strikeout Percentage", isCalculated: true) // needs calculation
  ],
};

// returns a dictionary of the calculated stats names as the key, and the values
Map<String, double> calculateStats(String sport, Map<String, double> inputs) {
  Map<String, double> results = {};
  if (sport == "Basketball") {
    // Only use this calculation when field goals attempted are entered for both types
    if (inputs.containsKey("2pt Field Goals Attempted") &&
        inputs.containsKey("3pt Field Goals Attempted")) {
      results["True Shooting Percentage"] =
      ((inputs["2pt Field Goals Made"] ?? 0) +
          ((inputs["3pt Field Goals Made"] ?? 0) * 1.5) /
              ((inputs["2pt Field Goals Attempted"] ?? 0) +
                  (inputs["3pt Field Goals Attempted"] ?? 0)) * 100);
    }
    // Use if no 3pts attempts are entered
    else if (inputs.containsKey("2pt Field Goals Attempted")) {
      results["True Shooting Percentage"] =
      ((inputs["2pt Field Goals Made"] ?? 0) /
          (inputs["2pt Field Goals Attempted"] ?? 0) * 100);
    }

    results["Pure Point Rating"] =
    ((inputs["Assists"] ?? 0) / ((inputs["Turnovers"] ?? 0)));

  }
  else if (sport == "Baseball") {
    // to be updated
    results["Batting Average"] =
    ((inputs["Hits"] ?? 0) / (inputs["At Bats"] ?? 0));

    results["Strikeout Rate"] =
    ((inputs["Pitcher Strikeouts"] ?? 0) / (inputs["Batters Faced"] ?? 0));
  } // more sports to come
  return results;
}

