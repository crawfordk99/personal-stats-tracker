import 'package:flutter_riverpod/flutter_riverpod.dart';


// Define a StateNotifier class to handle logic for selecting the sport
class StatsNotifier extends StateNotifier<String> {
  StatsNotifier() : super("Basketball"); // Default sport is Basketball

  void changeSport(String newSport) {
    state = newSport; // Update the state with the new sport
  }
}

// Define a provider for StatsNotifier
final statsProvider = StateNotifierProvider<StatsNotifier, String>((ref) {
  return StatsNotifier();
});
