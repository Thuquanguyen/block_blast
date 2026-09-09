import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../features/leaderboard/models/leaderboard_entry.dart';

/// Thin wrapper around Firebase Auth (anonymous) + Firestore for the global
/// leaderboard. Firebase.initializeApp() is guarded in main.dart, so if no
/// project is configured yet (or Firestore/Anonymous Auth aren't enabled in
/// the console) every call here simply fails and no-ops.
class LeaderboardService {
  static const _collection = 'leaderboard';

  // Accessed lazily (not as eager fields) because Get.put(LeaderboardService())
  // runs before Firebase.initializeApp() completes (see main.dart) — grabbing
  // FirebaseAuth.instance/FirebaseFirestore.instance eagerly throws
  // '[core/no-app]' the moment a real GoogleService-Info.plist is present.
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Future<String?> ensureSignedIn() async {
    try {
      final existing = _auth.currentUser;
      if (existing != null) return existing.uid;
      final credential = await _auth.signInAnonymously();
      return credential.user?.uid;
    } catch (e) {
      debugPrint('LeaderboardService: ensureSignedIn failed ($e)');
      return null;
    }
  }

  Future<void> submitScore({
    required int score,
    required String nickname,
  }) async {
    try {
      final uid = await ensureSignedIn();
      if (uid == null) return;
      await _firestore.collection(_collection).doc(uid).set({
        'nickname': nickname,
        'score': score,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('LeaderboardService: submitScore failed ($e)');
    }
  }

  Future<List<LeaderboardEntry>> topScores({int limit = 100}) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('score', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map(
            (doc) => LeaderboardEntry(
              uid: doc.id,
              nickname: (doc.data()['nickname'] as String?) ?? '',
              score: (doc.data()['score'] as num?)?.toInt() ?? 0,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('LeaderboardService: topScores failed ($e)');
      return [];
    }
  }

  Future<int?> myRank(int score) async {
    try {
      final uid = await ensureSignedIn();
      if (uid == null) return null;
      final aggregate = await _firestore
          .collection(_collection)
          .where('score', isGreaterThan: score)
          .count()
          .get();
      return (aggregate.count ?? 0) + 1;
    } catch (e) {
      debugPrint('LeaderboardService: myRank failed ($e)');
      return null;
    }
  }
}
