// lib/services/issue_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/issue_model.dart';
import '../models/enums.dart';
import '../models/location_model.dart';

class IssueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  // ============================================================
  // CREATE ISSUE
  // ============================================================

  Future<String?> createIssue(IssueModel issue) async {
    try {
      // Generate new document reference
      final docRef = _firestore.collection('issues').doc();

      // Create issue with generated ID
      final issueWithId = issue.copyWith(issueId: docRef.id);

      await docRef.set(issueWithId.toJson());

      debugPrint('✅ Issue created: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('❌ Error creating issue: $e');
      return null;
    }
  }

  // ============================================================
  // GET ISSUES (with filtering)
  // ============================================================

  /// Get issues for citizen home page with filter options
  /// filterType: 'ward', 'municipality', 'district'
  Stream<List<IssueModel>> getIssuesForCitizen({
    required String district,
    String? municipality,
    int? ward,
    required String filterType,
    IssueCategory? categoryFilter,
    IssueStatus? statusFilter,
    int limit = 20,
  }) {
    try {
      Query query = _firestore.collection('issues');

      // Apply location filters based on filterType
      if (filterType == 'ward' && municipality != null && ward != null) {
        // Show only ward issues
        query = query
            .where('issueLocation.district', isEqualTo: district)
            .where('issueLocation.municipality', isEqualTo: municipality)
            .where('issueLocation.ward', isEqualTo: ward);
      } else if (filterType == 'municipality' && municipality != null) {
        // Show all wards in municipality
        query = query
            .where('issueLocation.district', isEqualTo: district)
            .where('issueLocation.municipality', isEqualTo: municipality);
      } else if (filterType == 'district') {
        // Show entire district
        query = query.where('issueLocation.district', isEqualTo: district);
      }

      // Apply category filter
      if (categoryFilter != null) {
        query = query.where('category', isEqualTo: categoryFilter.toJson());
      }

      // Apply status filter
      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.toJson());
      }

      // Order by creation date (newest first)
      query = query.orderBy('createdAt', descending: true);

      // Limit results
      query = query.limit(limit);

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return IssueModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      debugPrint('❌ Error getting issues: $e');
      return Stream.value([]);
    }
  }

  /// Get issues for government dashboard (ward-locked)
  Stream<List<IssueModel>> getIssuesForGovernment({
    required String district,
    required String municipality,
    required int ward,
    IssueCategory? categoryFilter,
    IssueStatus? statusFilter,
  }) {
    try {
      Query query = _firestore.collection('issues');

      // LOCKED to specific ward
      query = query
          .where('issueLocation.district', isEqualTo: district)
          .where('issueLocation.municipality', isEqualTo: municipality)
          .where('issueLocation.ward', isEqualTo: ward);

      // Apply category filter
      if (categoryFilter != null) {
        query = query.where('category', isEqualTo: categoryFilter.toJson());
      }

      // Apply status filter
      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.toJson());
      }

      // Order by creation date
      query = query.orderBy('createdAt', descending: true);

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return IssueModel.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      debugPrint('❌ Error getting government issues: $e');
      return Stream.value([]);
    }
  }

  /// Get user's own issues
  Stream<List<IssueModel>> getUserIssues(String userId) {
    try {
      return _firestore
          .collection('issues')
          .where('reportedBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return IssueModel.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();
          });
    } catch (e) {
      debugPrint('❌ Error getting user issues: $e');
      return Stream.value([]);
    }
  }

  /// Get single issue by ID
  Future<IssueModel?> getIssueById(String issueId) async {
    try {
      final doc = await _firestore.collection('issues').doc(issueId).get();

      if (doc.exists) {
        return IssueModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting issue: $e');
      return null;
    }
  }

  // ============================================================
  // UPDATE ISSUE
  // ============================================================

  /// Update issue status (for government only)
  Future<bool> updateIssueStatus({
    required String issueId,
    required IssueStatus newStatus,
    required String updatedBy,
  }) async {
    try {
      await _firestore.collection('issues').doc(issueId).update({
        'status': newStatus.toJson(),
        'statusUpdatedAt': FieldValue.serverTimestamp(),
        'statusUpdatedBy': updatedBy,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Issue status updated: $issueId');
      return true;
    } catch (e) {
      debugPrint('❌ Error updating issue status: $e');
      return false;
    }
  }

  /// Update entire issue (for reporter only)
  Future<bool> updateIssue(IssueModel issue) async {
    try {
      await _firestore
          .collection('issues')
          .doc(issue.issueId)
          .update(issue.toJson());

      debugPrint('✅ Issue updated: ${issue.issueId}');
      return true;
    } catch (e) {
      debugPrint('❌ Error updating issue: $e');
      return false;
    }
  }

  /// Increment view count
  Future<void> incrementViewCount(String issueId) async {
    try {
      await _firestore.collection('issues').doc(issueId).update({
        'viewsCount': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('❌ Error incrementing view count: $e');
    }
  }

  /// Increment reaction count
  Future<void> incrementReactionCount(String issueId) async {
    try {
      await _firestore.collection('issues').doc(issueId).update({
        'reactionsCount': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('❌ Error incrementing reaction count: $e');
    }
  }

  /// Decrement reaction count
  Future<void> decrementReactionCount(String issueId) async {
    try {
      await _firestore.collection('issues').doc(issueId).update({
        'reactionsCount': FieldValue.increment(-1),
      });
    } catch (e) {
      debugPrint('❌ Error decrementing reaction count: $e');
    }
  }

  /// Increment comment count
  Future<void> incrementCommentCount(String issueId) async {
    try {
      await _firestore.collection('issues').doc(issueId).update({
        'commentsCount': FieldValue.increment(1),
      });
    } catch (e) {
      debugPrint('❌ Error incrementing comment count: $e');
    }
  }

  // ============================================================
  // DELETE ISSUE
  // ============================================================

  Future<bool> deleteIssue(String issueId) async {
    try {
      await _firestore.collection('issues').doc(issueId).delete();

      debugPrint('✅ Issue deleted: $issueId');
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting issue: $e');
      return false;
    }
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  /// Get issue counts by status for a location
  Future<Map<String, int>> getIssueCountsByStatus({
    required String district,
    String? municipality,
    int? ward,
  }) async {
    try {
      Query query = _firestore.collection('issues');

      // Apply location filters
      if (ward != null && municipality != null) {
        query = query
            .where('issueLocation.district', isEqualTo: district)
            .where('issueLocation.municipality', isEqualTo: municipality)
            .where('issueLocation.ward', isEqualTo: ward);
      } else if (municipality != null) {
        query = query
            .where('issueLocation.district', isEqualTo: district)
            .where('issueLocation.municipality', isEqualTo: municipality);
      } else {
        query = query.where('issueLocation.district', isEqualTo: district);
      }

      final snapshot = await query.get();

      int notStarted = 0;
      int inProgress = 0;
      int completed = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] as String;

        if (status == 'not_started') {
          notStarted++;
        } else if (status == 'in_progress') {
          inProgress++;
        } else if (status == 'completed') {
          completed++;
        }
      }

      return {
        'notStarted': notStarted,
        'inProgress': inProgress,
        'completed': completed,
        'total': snapshot.docs.length,
      };
    } catch (e) {
      debugPrint('❌ Error getting issue counts: $e');
      return {'notStarted': 0, 'inProgress': 0, 'completed': 0, 'total': 0};
    }
  }

  // Update issue with image URLs
  Future<bool> updateIssueImages(String issueId, List<String> imageUrls) async {
    try {
      await _firestore.collection('issues').doc(issueId).update({
        'imageUrls': imageUrls,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Issue images updated: $issueId');
      return true;
    } catch (e) {
      debugPrint('❌ Error updating issue images: $e');
      return false;
    }
  }
}
