// lib/models/notification_model.dart

import 'enums.dart';

class NotificationModel {
  final String notificationId;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final String? actionText;
  final String? relatedIssueId;
  final String? relatedUserId;
  final String? relatedUserName;
  final bool isRead;
  final String priority;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? readAt;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.actionText,
    this.relatedIssueId,
    this.relatedUserId,
    this.relatedUserName,
    this.isRead = false,
    this.priority = 'normal',
    this.imageUrl,
    required this.createdAt,
    this.readAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'type': type.toJson(),
      'title': title,
      'message': message,
      if (actionText != null) 'actionText': actionText,
      if (relatedIssueId != null) 'relatedIssueId': relatedIssueId,
      if (relatedUserId != null) 'relatedUserId': relatedUserId,
      if (relatedUserName != null) 'relatedUserName': relatedUserName,
      'isRead': isRead,
      'priority': priority,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': createdAt,
      if (readAt != null) 'readAt': readAt,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] as String,
      userId: json['userId'] as String,
      type: NotificationType.fromJson(json['type'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      actionText: json['actionText'] as String?,
      relatedIssueId: json['relatedIssueId'] as String?,
      relatedUserId: json['relatedUserId'] as String?,
      relatedUserName: json['relatedUserName'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      priority: json['priority'] as String? ?? 'normal',
      imageUrl: json['imageUrl'] as String?,
      createdAt: (json['createdAt'] as dynamic).toDate(),
      readAt: json['readAt'] != null
          ? (json['readAt'] as dynamic).toDate()
          : null,
    );
  }

  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    String? actionText,
    String? relatedIssueId,
    String? relatedUserId,
    String? relatedUserName,
    bool? isRead,
    String? priority,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      actionText: actionText ?? this.actionText,
      relatedIssueId: relatedIssueId ?? this.relatedIssueId,
      relatedUserId: relatedUserId ?? this.relatedUserId,
      relatedUserName: relatedUserName ?? this.relatedUserName,
      isRead: isRead ?? this.isRead,
      priority: priority ?? this.priority,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }
}