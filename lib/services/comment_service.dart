// lib/services/comment_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  // CREATE COMMENT
  // ============================================================

  Future<String?> addComment({
    required String issueId,
    required CommentModel comment,
  }) async {
    try {
      // Generate new comment document
      final docRef = _firestore
          .collection('issues')
          .doc(issueId)
          .collection('comments')
          .doc();

      // Create comment with generated ID
      final commentWithId = comment.copyWith(commentId: docRef.id);

      await docRef.set(commentWithId.toJson());

      // Increment comment count on issue
      await _firestore.collection('issues').doc(issueId).update({
        'commentsCount': FieldValue.increment(1),
      });

      debugPrint('✅ Comment added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error adding comment: $e');
      return null;
    }
  }

  // ============================================================
  // GET COMMENTS
  // ============================================================

  /// Get all comments for an issue (real-time)
  Stream<List<CommentModel>> getComments(String issueId) {
    try {
      return _firestore
          .collection('issues')
          .doc(issueId)
          .collection('comments')
          .orderBy('createdAt', descending: false) // Oldest first
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return CommentModel.fromJson(doc.data());
            }).toList();
          });
    } catch (e) {
      debugPrint('❌ Error getting comments: $e');
      return Stream.value([]);
    }
  }

  /// Get comments count for an issue
  Future<int> getCommentsCount(String issueId) async {
    try {
      final snapshot = await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('comments')
          .get();

      return snapshot.docs.length;
    } catch (e) {
      debugPrint('❌ Error getting comments count: $e');
      return 0;
    }
  }

  // ============================================================
  // UPDATE COMMENT
  // ============================================================

  Future<bool> updateComment({
    required String issueId,
    required String commentId,
    required String newText,
  }) async {
    try {
      await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('comments')
          .doc(commentId)
          .update({
            'text': newText,
            'updatedAt': FieldValue.serverTimestamp(),
            'isEdited': true,
          });

      debugPrint('✅ Comment updated: $commentId');
      return true;
    } catch (e) {
      debugPrint('❌ Error updating comment: $e');
      return false;
    }
  }

  // ============================================================
  // DELETE COMMENT
  // ============================================================

  Future<bool> deleteComment({
    required String issueId,
    required String commentId,
  }) async {
    try {
      await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('comments')
          .doc(commentId)
          .delete();

      // Decrement comment count on issue
      await _firestore.collection('issues').doc(issueId).update({
        'commentsCount': FieldValue.increment(-1),
      });

      debugPrint('✅ Comment deleted: $commentId');
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting comment: $e');
      return false;
    }
  }

  // ============================================================
  // GET RECENT COMMENTS (for preview)
  // ============================================================

  /// Get first N comments for preview
  Future<List<CommentModel>> getRecentComments({
    required String issueId,
    int limit = 2,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('issues')
          .doc(issueId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        return CommentModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      debugPrint('❌ Error getting recent comments: $e');
      return [];
    }
  }
}

