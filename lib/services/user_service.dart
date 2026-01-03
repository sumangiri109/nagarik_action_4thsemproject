// lib/services/user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nagarik_action_4thsemproject/models/user_models.dart';
import '../models/enums.dart';
import '../models/location_model.dart';
import '../models/government_details_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  // CREATE USER
  // ============================================================

  /// Create a new user document in Firestore
  Future<void> createUser({
    required String uid,
    required String email,
    required String name,
    required UserRole role,
    required String district,
    required String municipality,
    required int ward,
    String? specificLocation,
    String? phoneNumber,
    String? profileImageUrl,
    String? bio,
    // Government-specific fields
    String? officeName,
    String? position,
    String? department,
    String? officeEmail,
    String? officePhone,
    String? certificateUrl,
  }) async {
    try {
      // Create Location object
      final location = Location(
        district: district,
        municipality: municipality,
        ward: ward,
        specificLocation: specificLocation,
      );

      // Create GovernmentDetails if government user
      GovernmentDetails? governmentDetails;
      VerificationStatus? verificationStatus;

      if (role == UserRole.government) {
        if (officeName == null || position == null) {
          throw Exception('Office name and position are required for government users');
        }

        governmentDetails = GovernmentDetails(
          officeName: officeName,
          position: position,
          department: department,
          officeEmail: officeEmail,
          officePhone: officePhone,
        );

        // Government users start as pending
        verificationStatus = VerificationStatus.pending;
      }

      // Create UserModel
      final user = UserModel(
        uid: uid,
        email: email,
        name: name,
        role: role,
        location: location,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        profileImageUrl: profileImageUrl,
        phoneNumber: phoneNumber,
        bio: bio,
        verificationStatus: verificationStatus,
        certificateUrl: certificateUrl,
        governmentDetails: governmentDetails,
      );

      // Save to Firestore
      await _firestore.collection('users').doc(uid).set(user.toJson());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  // ============================================================
  // GET USER
  // ============================================================

  /// Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Get user stream (real-time updates)
  Stream<UserModel?> getUserStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return UserModel.fromJson(doc.data()!);
        });
  }

  // ============================================================
  // UPDATE USER
  // ============================================================

  /// Update user profile
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      // Add updatedAt timestamp
      data['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Update user name
  Future<void> updateUserName(String uid, String name) async {
    await updateUser(uid, {'name': name});
  }

  /// Update user phone
  Future<void> updateUserPhone(String uid, String phoneNumber) async {
    await updateUser(uid, {'phoneNumber': phoneNumber});
  }

  /// Update user bio
  Future<void> updateUserBio(String uid, String bio) async {
    await updateUser(uid, {'bio': bio});
  }

  /// Update profile image
  Future<void> updateProfileImage(String uid, String imageUrl) async {
    await updateUser(uid, {'profileImageUrl': imageUrl});
  }

  /// Update location
  Future<void> updateLocation({
    required String uid,
    required String district,
    required String municipality,
    required int ward,
    String? specificLocation,
  }) async {
    final location = Location(
      district: district,
      municipality: municipality,
      ward: ward,
      specificLocation: specificLocation,
    );

    await updateUser(uid, {'location': location.toJson()});
  }

  // ============================================================
  // GOVERNMENT USER VERIFICATION (ADMIN ONLY)
  // ============================================================

  /// Approve government user
  Future<void> approveGovernmentUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'verificationStatus': VerificationStatus.approved.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error approving government user: $e');
      rethrow;
    }
  }

  /// Reject government user
  Future<void> rejectGovernmentUser(String uid, String reason) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'verificationStatus': VerificationStatus.rejected.toJson(),
        'rejectionReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error rejecting government user: $e');
      rethrow;
    }
  }

  /// Get all pending government users (for admin)
  Stream<List<UserModel>> getPendingGovernmentUsers() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: UserRole.government.toJson())
        .where('verificationStatus', isEqualTo: VerificationStatus.pending.toJson())
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => UserModel.fromJson(doc.data()))
              .toList();
        });
  }

  /// Get all government users by location (for admin)
  Future<List<UserModel>> getGovernmentUsersByLocation({
    required String district,
    required String municipality,
    required int ward,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: UserRole.government.toJson())
          .where('location.district', isEqualTo: district)
          .where('location.municipality', isEqualTo: municipality)
          .where('location.ward', isEqualTo: ward)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting government users by location: $e');
      return [];
    }
  }

  // ============================================================
  // DELETE USER
  // ============================================================

  /// Delete user document
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // ============================================================
  // QUERY USERS
  // ============================================================

  /// Get users by role
  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: role.toJson())
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting users by role: $e');
      return [];
    }
  }

  /// Get users by location (same ward)
  Future<List<UserModel>> getUsersByLocation({
    required String district,
    required String municipality,
    required int ward,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('location.district', isEqualTo: district)
          .where('location.municipality', isEqualTo: municipality)
          .where('location.ward', isEqualTo: ward)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting users by location: $e');
      return [];
    }
  }

  /// Search users by name
  Future<List<UserModel>> searchUsersByName(String searchTerm) async {
    try {
      // Note: Firestore doesn't support full-text search
      // This is a basic implementation that filters client-side
      final snapshot = await _firestore.collection('users').get();

      final allUsers = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();

      // Filter by name (case-insensitive)
      return allUsers.where((user) {
        return user.name.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }
}