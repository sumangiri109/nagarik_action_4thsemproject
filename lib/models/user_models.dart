// lib/models/user_model.dart

import 'enums.dart';
import 'location_model.dart';
import 'government_details_model.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final Location location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profileImageUrl;
  final String? phoneNumber;
  final String? bio;
  
  // Government-specific fields
  final VerificationStatus? verificationStatus;
  final String? certificateUrl;
  final String? rejectionReason;
  final GovernmentDetails? governmentDetails;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    this.profileImageUrl,
    this.phoneNumber,
    this.bio,
    this.verificationStatus,
    this.certificateUrl,
    this.rejectionReason,
    this.governmentDetails,
  });

  // Check if user is government and verified
  bool get isVerifiedGovernment =>
      role == UserRole.government && 
      verificationStatus == VerificationStatus.approved;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role.toJson(),
      'location': location.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (bio != null) 'bio': bio,
      if (verificationStatus != null) 
        'verificationStatus': verificationStatus!.toJson(),
      if (certificateUrl != null) 'certificateUrl': certificateUrl,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (governmentDetails != null) 
        'governmentDetails': governmentDetails!.toJson(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.fromJson(json['role'] as String),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      createdAt: (json['createdAt'] as dynamic).toDate(),
      updatedAt: (json['updatedAt'] as dynamic).toDate(),
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      bio: json['bio'] as String?,
      verificationStatus: json['verificationStatus'] != null
          ? VerificationStatus.fromJson(json['verificationStatus'] as String)
          : null,
      certificateUrl: json['certificateUrl'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      governmentDetails: json['governmentDetails'] != null
          ? GovernmentDetails.fromJson(
              json['governmentDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    UserRole? role,
    Location? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileImageUrl,
    String? phoneNumber,
    String? bio,
    VerificationStatus? verificationStatus,
    String? certificateUrl,
    String? rejectionReason,
    GovernmentDetails? governmentDetails,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      governmentDetails: governmentDetails ?? this.governmentDetails,
    );
  }
}