// lib/models/comment_model.dart

import 'enums.dart';

class CommentModel {
  final String commentId;
  final String userId;
  final String userName;
  final UserRole userRole;
  final String? userProfileImage;
  final String text;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isEdited;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.userRole,
    this.userProfileImage,
    required this.text,
    required this.createdAt,
    this.updatedAt,
    this.isEdited = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'userRole': userRole.toJson(),
      if (userProfileImage != null) 'userProfileImage': userProfileImage,
      'text': text,
      'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      'isEdited': isEdited,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userRole: UserRole.fromJson(json['userRole'] as String),
      userProfileImage: json['userProfileImage'] as String?,
      text: json['text'] as String,
      createdAt: (json['createdAt'] as dynamic).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as dynamic).toDate()
          : null,
      isEdited: json['isEdited'] as bool? ?? false,
    );
  }

  CommentModel copyWith({
    String? commentId,
    String? userId,
    String? userName,
    UserRole? userRole,
    String? userProfileImage,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEdited,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}