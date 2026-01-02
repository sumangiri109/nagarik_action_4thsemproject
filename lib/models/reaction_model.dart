// lib/models/reaction_model.dart

import 'enums.dart';

class ReactionModel {
  final String userId;
  final String userName;
  final String? userProfileImage;
  final ReactionType reactionType;
  final DateTime createdAt;

  ReactionModel({
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.reactionType,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      if (userProfileImage != null) 'userProfileImage': userProfileImage,
      'reactionType': reactionType.toJson(),
      'createdAt': createdAt,
    };
  }

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userProfileImage: json['userProfileImage'] as String?,
      reactionType: ReactionType.fromJson(json['reactionType'] as String),
      createdAt: (json['createdAt'] as dynamic).toDate(),
    );
  }

  ReactionModel copyWith({
    String? userId,
    String? userName,
    String? userProfileImage,
    ReactionType? reactionType,
    DateTime? createdAt,
  }) {
    return ReactionModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      reactionType: reactionType ?? this.reactionType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}