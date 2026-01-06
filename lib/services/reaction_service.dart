
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/reaction_model.dart';
import '../models/enums.dart';

class ReactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  // ADD/REMOVE REACTION (Toggle)
  // ============================================================

  /// Toggle reaction (add if doesn't exist, remove if exists)
  Future<bool> toggleReaction({
    required String issueId,
    required String userId,
    required String userName,
    ReactionType reactionType = ReactionType.support,
  }) async {
    try {
      final reactionRef = _firestore
          .collection('issues')
          .doc(issueId)
          .collection('reactions')
          .doc(userId);

      final reactionDoc = await reactionRef.get();

      if (reactionDoc.exists) {
        // Reaction exists - REMOVE it
        await reactionRef.delete();

        // Decrement reaction count
        await _firestore.collection('issues').doc(issueId).update({
          'reactionsCount': FieldValue.increment(-1),
        });

        debugPrint('✅ Reaction removed: $userId');
        return false; // Indicates reaction was removed
      } else {
        // Reaction doesn't exist - ADD it
        final reaction = ReactionModel(
          userId: userId,
          userName: userName,
          reactionType: reactionType,
          createdAt: DateTime.now(),
        );

        await reactionRef.set(reaction.toJson());

        // Increment reaction count
        await _firestore.collection('issues').doc(issueId).update({
          'reactionsCount': FieldValue.increment(1),
        });

        debugPrint('✅ Reaction added: $userId');
        return true; // Indicates reaction was added
      }
    } catch (e) {
      debugPrint('❌ Error toggling reaction: $e');
      return false;
    }
  }

  // ============================================================
  // CHECK IF USER REACTED
  // ============================================================

  /// Check if user has reacted to an issue
  Future<bool> hasUserReacted({
    required String issueId,
    required String userId,
  }) async {
    try {
      final reactionDoc = await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('reactions')
          .doc(userId)
          .get();

      return reactionDoc.exists;
    } catch (e) {
      debugPrint('❌ Error checking user reaction: $e');
      return false;
    }
  }

  /// Get user's reaction (if exists)
  Future<ReactionModel?> getUserReaction({
    required String issueId,
    required String userId,
  }) async {
    try {
      final reactionDoc = await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('reactions')
          .doc(userId)
          .get();

      if (reactionDoc.exists) {
        return ReactionModel.fromJson(reactionDoc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting user reaction: $e');
      return null;
    }
  }

  // ============================================================
  // GET ALL REACTIONS
  // ============================================================

  /// Get all reactions for an issue
  Stream<List<ReactionModel>> getReactions(String issueId) {
    try {
      return _firestore
          .collection('issues')
          .doc(issueId)
          .collection('reactions')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ReactionModel.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      debugPrint('❌ Error getting reactions: $e');
      return Stream.value([]);
    }
  }

  /// Get reactions count
  Future<int> getReactionsCount(String issueId) async {
    try {
      final snapshot = await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('reactions')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint('❌ Error getting reactions count: $e');
      return 0;
    }
  }

  // ============================================================
  // GET REACTIONS BY TYPE
  // ============================================================

  /// Get count of reactions by type
  Future<Map<ReactionType, int>> getReactionsByType(String issueId) async {
    try {
      final snapshot = await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('reactions')
          .get();

      Map<ReactionType, int> counts = {
        ReactionType.support: 0,
        ReactionType.concern: 0,
        ReactionType.angry: 0,
        ReactionType.sad: 0,
      };

      for (var doc in snapshot.docs) {
        final reaction = ReactionModel.fromJson(doc.data());
        counts[reaction.reactionType] = (counts[reaction.reactionType] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      debugPrint('❌ Error getting reactions by type: $e');
      return {};
    }
  }

  // ============================================================
  // UPDATE REACTION TYPE
  // ============================================================

  /// Change reaction type (e.g., from support to angry)
  Future<bool> updateReactionType({
    required String issueId,
    required String userId,
    required ReactionType newType,
  }) async {
    try {
      await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('reactions')
          .doc(userId)
          .update({
        'reactionType': newType.toJson(),
      });

      debugPrint('✅ Reaction type updated: $userId');
      return true;
    } catch (e) {
      debugPrint('❌ Error updating reaction type: $e');
      return false;
    }
  }

  // ============================================================
  // REMOVE REACTION
  // ============================================================

  Future<bool> removeReaction({
    required String issueId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('reactions')
          .doc(userId)
          .delete();

      // Decrement reaction count
      await _firestore.collection('issues').doc(issueId).update({
        'reactionsCount': FieldValue.increment(-1),
      });

      debugPrint('✅ Reaction removed: $userId');
      return true;
    } catch (e) {
      debugPrint('❌ Error removing reaction: $e');
      return false;
    }
  }
}