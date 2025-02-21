import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_stats_tracker/services/firebase_auth.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _auth = FirebaseAuthService();

  User? get user => _auth.getCurrentUser();

  String? get userId => user?.uid;

  Future<void> saveStats(
      String sport,
      Map<String, dynamic> stats,
      ) async {
    if (userId == null) {
      throw Exception("No user logged in!");
    }

    await _firestore 
      .collection("users")
      .doc(userId)
      .collection("stats")
      .doc(sport)
      .collection("entries")
      .add({
      "timestamp": FieldValue.serverTimestamp(), ...stats,
    });


  }
  /// Retrieve stats for a specific sport (sorted by timestamp)
  Stream<QuerySnapshot> getStatsStream(String sport) {
    if (userId == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection("users")
        .doc(userId)
        .collection("stats")
        .doc(sport)
        .collection("entries")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<void> deleteUserStats(String sport, String statId) async {
    if (userId == null) {
      throw Exception("No user logged in!");
    }

    await _firestore
        .collection("users")
        .doc(userId)
        .collection("stats")
        .doc(sport)
        .collection("entries")
        .doc(statId)
        .delete();
  }

}