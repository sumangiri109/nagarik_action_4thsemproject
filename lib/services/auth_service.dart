// lib/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/enums.dart';
import 'user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Get current user ID
  String? get currentUserId => currentUser?.uid;

  // ============================================================
  // GOOGLE SIGN IN
  // ============================================================

  /// Sign in with Google
  /// Returns the Firebase User if successful, null if cancelled
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels the sign-in
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  // ============================================================
  // CHECK USER EXISTS
  // ============================================================

  /// Check if user document exists in Firestore
  Future<bool> checkUserExists(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('Error checking user exists: $e');
      return false;
    }
  }

  /// Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (!doc.exists) {
        return null;
      }

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // ============================================================
  // COMPLETE SIGNUP FLOW
  // ============================================================

  /// Complete signup flow after Google Sign-in
  /// This creates the user document in Firestore
  Future<void> completeSignup({
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
    // Government-specific fields
    String? officeName,
    String? position,
    String? department,
    String? officeEmail,
    String? officePhone,
    String? certificateUrl,
  }) async {
    try {
      await _userService.createUser(
        uid: uid,
        email: email,
        name: name,
        role: role,
        district: district,
        municipality: municipality,
        ward: ward,
        specificLocation: specificLocation,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
        officeName: officeName,
        position: position,
        department: department,
        officeEmail: officeEmail,
        officePhone: officePhone,
        certificateUrl: certificateUrl,
      );
    } catch (e) {
      print('Error completing signup: $e');
      rethrow;
    }
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  /// Sign out from Firebase and Google
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // ============================================================
  // DELETE ACCOUNT
  // ============================================================

  /// Delete user account (both Auth and Firestore)
  Future<void> deleteAccount() async {
    try {
      final uid = currentUserId;
      if (uid == null) throw Exception('No user logged in');

      // Delete Firestore document
      await _firestore.collection('users').doc(uid).delete();

      // Delete Firebase Auth account
      await currentUser?.delete();

      // Sign out from Google
      await _googleSignIn.signOut();
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }

  // ============================================================
  // RE-AUTHENTICATE (for sensitive operations)
  // ============================================================

  /// Re-authenticate user with Google (required for sensitive operations)
  Future<void> reauthenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Re-authentication cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await currentUser?.reauthenticateWithCredential(credential);
    } catch (e) {
      print('Error re-authenticating: $e');
      rethrow;
    }
  }

  // ============================================================
  // GET CURRENT USER MODEL
  // ============================================================

  /// Get current user's complete data as UserModel
  Future<UserModel?> getCurrentUserModel() async {
    try {
      final uid = currentUserId;
      if (uid == null) return null;

      return await getUserData(uid);
    } catch (e) {
      print('Error getting current user model: $e');
      return null;
    }
  }

  /// Stream of current user's data
  Stream<UserModel?> getCurrentUserStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return null;
          return UserModel.fromJson(doc.data()!);
        });
  }
}