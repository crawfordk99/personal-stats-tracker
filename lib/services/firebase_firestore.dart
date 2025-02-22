import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_stats_tracker/services/firebase_auth.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService _auth = FirebaseAuthService();

  void connectFirestoreEmulator() {
    _firestore.useFirestoreEmulator('localhost', 8080);
  }

  User? get user => _auth.getCurrentUser();

  String? get userId => user?.uid;

  Future<void> saveOrUpdateStats(
      String sport,
      Map<String, dynamic> stats,
      ) async {
    if (userId == null) {
      throw Exception("No user logged in!");
    }

    // Reference the stats collection
    var statsCollection = _firestore
        .collection("users")
        .doc(userId)
        .collection("stats")
        .doc(sport)
        .collection("entries");

    // Check if an entry exists
    var existingStats = await statsCollection.orderBy("timestamp", descending: true).limit(1).get();

    if (existingStats.docs.isNotEmpty) {
      // If an entry exists, update the latest one
      var docId = existingStats.docs.first.id;
      await statsCollection.doc(docId).update(stats);
    } else {
      // If no entry exists, create a new one
      await statsCollection.add({
        "timestamp": FieldValue.serverTimestamp(),
        ...stats,
      });
    }

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

  Future<void> deleteUserStats(String sport, String? statId) async {
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