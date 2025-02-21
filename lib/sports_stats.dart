/* This class will handle calculations for shooting percentages*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SportsStats {
  String name;
  TextEditingController controller;
  bool isCalculated;

  SportsStats(this.name, {this.isCalculated = false})
    : controller = TextEditingController();
}
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
Map<String, double> calculateStats(String sport, Map<String, double> inputs) {
  Map<String, double> results = {};
  if (sport == "Basketball") {
    if (inputs.containsKey("2pt Field Goals Attempted") &&
        inputs.containsKey("3pt Field Goals Attempted")) {
      results["True Shooting Percentage"] =
      ((inputs["2pt Field Goals Made"] ?? 0) +
          ((inputs["3pt Field Goals Made"] ?? 0) * 1.5) /
              ((inputs["2pt Field Goals Attempted"] ?? 0) +
                  (inputs["3pt Field Goals Attempted"] ?? 0)) * 100);
    }
    else if (inputs.containsKey("2pt Field Goals Attempted")) {
      results["True Shooting Percentage"] =
      ((inputs["2pt Field Goals Made"] ?? 0) /
          (inputs["2pt Field Goals Attempted"] ?? 0) * 100);
    }

    results["Pure Point Percentage"] =
    ((inputs["Assists"] ?? 0) / ((inputs["Turnovers"] ?? 0) * 2) * 100);

  }
  else if (sport == "Baseball") {
    results["Batting Average"] =
    ((inputs["Hits"] ?? 0) / (inputs["At Bats"] ?? 0));

    results["Strikeout Rate"] =
    ((inputs["Pitcher Strikeouts"] ?? 0) / (inputs["Batters Faced"] ?? 0));
  }
  return results;
}

