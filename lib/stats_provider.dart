import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:personal_stats_tracker/sports_stats.dart';
import 'package:collection/collection.dart';

final statsProvider = ChangeNotifierProvider((ref) => StatsNotifier());

class StatsNotifier extends ChangeNotifier {
  String selectedSport = "Basketball";
  Map<String, double> calculatedStats = {};

  // from collection.dart, allows for checking if a map equals a map (dictionaries)
  final _mapEquality = MapEquality();

  void updateStats(Map<String, double> inputs) {
    final newStats = calculateStats(selectedSport, inputs);
    if (!_mapEquality.equals(calculatedStats, newStats)) {
      calculatedStats = newStats;
      notifyListeners(); // UI updates only when necessary
    }
  }

  void changeSport(String newSport) {
    selectedSport = newSport;
    calculatedStats.clear();
    notifyListeners();
  }
}