// lib/models/issue_model.dart

import 'enums.dart';
import 'location_model.dart';

class IssueModel {
  final String issueId;
  final String title;
  final String description;
  final IssueCategory category;
  final String reportedBy;
  final String reporterName;
  final String reporterEmail;
  final Location location;
  final IssueStatus status;
  final IssuePriority? priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? statusUpdatedAt;
  final String? statusUpdatedBy;
  final List<String> imageUrls;
  final List<String> attachmentUrls;
  final int viewsCount;
  final int reactionsCount;
  final int commentsCount;
  final List<String> tags;
  final bool isAnonymous;

  IssueModel({
    required this.issueId,
    required this.title,
    required this.description,
    required this.category,
    required this.reportedBy,
    required this.reporterName,
    required this.reporterEmail,
    required this.location,
    required this.status,
    this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.statusUpdatedAt,
    this.statusUpdatedBy,
    this.imageUrls = const [],
    this.attachmentUrls = const [],
    this.viewsCount = 0,
    this.reactionsCount = 0,
    this.commentsCount = 0,
    this.tags = const [],
    this.isAnonymous = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'issueId': issueId,
      'title': title,
      'description': description,
      'category': category.toJson(),
      'reportedBy': reportedBy,
      'reporterName': reporterName,
      'reporterEmail': reporterEmail,
      'location': location.toJson(),
      'status': status.toJson(),
      if (priority != null) 'priority': priority!.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (statusUpdatedAt != null) 'statusUpdatedAt': statusUpdatedAt,
      if (statusUpdatedBy != null) 'statusUpdatedBy': statusUpdatedBy,
      'imageUrls': imageUrls,
      'attachmentUrls': attachmentUrls,
      'viewsCount': viewsCount,
      'reactionsCount': reactionsCount,
      'commentsCount': commentsCount,
      'tags': tags,
      'isAnonymous': isAnonymous,
    };
  }

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      issueId: json['issueId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: IssueCategory.fromJson(json['category'] as String),
      reportedBy: json['reportedBy'] as String,
      reporterName: json['reporterName'] as String,
      reporterEmail: json['reporterEmail'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      status: IssueStatus.fromJson(json['status'] as String),
      priority: json['priority'] != null
          ? IssuePriority.fromJson(json['priority'] as String)
          : null,
      createdAt: (json['createdAt'] as dynamic).toDate(),
      updatedAt: (json['updatedAt'] as dynamic).toDate(),
      statusUpdatedAt: json['statusUpdatedAt'] != null
          ? (json['statusUpdatedAt'] as dynamic).toDate()
          : null,
      statusUpdatedBy: json['statusUpdatedBy'] as String?,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      attachmentUrls: List<String>.from(json['attachmentUrls'] ?? []),
      viewsCount: json['viewsCount'] as int? ?? 0,
      reactionsCount: json['reactionsCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      isAnonymous: json['isAnonymous'] as bool? ?? false,
    );
  }

  IssueModel copyWith({
    String? issueId,
    String? title,
    String? description,
    IssueCategory? category,
    String? reportedBy,
    String? reporterName,
    String? reporterEmail,
    Location? location,
    IssueStatus? status,
    IssuePriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? statusUpdatedAt,
    String? statusUpdatedBy,
    List<String>? imageUrls,
    List<String>? attachmentUrls,
    int? viewsCount,
    int? reactionsCount,
    int? commentsCount,
    List<String>? tags,
    bool? isAnonymous,
  }) {
    return IssueModel(
      issueId: issueId ?? this.issueId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      reportedBy: reportedBy ?? this.reportedBy,
      reporterName: reporterName ?? this.reporterName,
      reporterEmail: reporterEmail ?? this.reporterEmail,
      location: location ?? this.location,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusUpdatedAt: statusUpdatedAt ?? this.statusUpdatedAt,
      statusUpdatedBy: statusUpdatedBy ?? this.statusUpdatedBy,
      imageUrls: imageUrls ?? this.imageUrls,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      viewsCount: viewsCount ?? this.viewsCount,
      reactionsCount: reactionsCount ?? this.reactionsCount,
      commentsCount: commentsCount ?? this.commentsCount,
      tags: tags ?? this.tags,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}