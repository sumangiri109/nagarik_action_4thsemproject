// lib/models/status_update_model.dart

import 'enums.dart';

class StatusUpdateModel {
  final String updateId;
  final IssueStatus previousStatus;
  final IssueStatus newStatus;
  final String updatedBy;
  final String updatedByName;
  final UserRole updatedByRole;
  final String? note;
  final List<String> attachmentUrls;
  final DateTime createdAt;

  StatusUpdateModel({
    required this.updateId,
    required this.previousStatus,
    required this.newStatus,
    required this.updatedBy,
    required this.updatedByName,
    required this.updatedByRole,
    this.note,
    this.attachmentUrls = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'updateId': updateId,
      'previousStatus': previousStatus.toJson(),
      'newStatus': newStatus.toJson(),
      'updatedBy': updatedBy,
      'updatedByName': updatedByName,
      'updatedByRole': updatedByRole.toJson(),
      if (note != null) 'note': note,
      'attachmentUrls': attachmentUrls,
      'createdAt': createdAt,
    };
  }

  factory StatusUpdateModel.fromJson(Map<String, dynamic> json) {
    return StatusUpdateModel(
      updateId: json['updateId'] as String,
      previousStatus: IssueStatus.fromJson(json['previousStatus'] as String),
      newStatus: IssueStatus.fromJson(json['newStatus'] as String),
      updatedBy: json['updatedBy'] as String,
      updatedByName: json['updatedByName'] as String,
      updatedByRole: UserRole.fromJson(json['updatedByRole'] as String),
      note: json['note'] as String?,
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
      createdAt: (json['createdAt'] as dynamic).toDate(),
    );
  }
}