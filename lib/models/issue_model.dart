// lib/models/issue_model.dart

import 'enums.dart';
import 'location_model.dart';

class IssueModel {
  final String issueId;
  final String title;
  final String description;
  final IssueCategory category;

  // Reporter information
  final String reportedBy;
  final String reporterName;
  final String reporterEmail;

  // NEW: Two separate locations
  final Location issueLocation; // Where the problem actually is
  final Location reporterRegisteredLocation; // Reporter's home address
  final bool isReportedFromDifferentDistrict; // Flag for cross-district reports

  // Issue details
  final IssueStatus status;
  final IssuePriority? priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? statusUpdatedAt;
  final String? statusUpdatedBy;

  // Media
  final List<String> imageUrls;
  final List<String> attachmentUrls;

  // Engagement metrics
  final int viewsCount;
  final int reactionsCount;
  final int commentsCount;

  // Optional fields
  final List<String> tags;
  final bool isAnonymous;
  final String? specificLocation; // Additional location details

  IssueModel({
    required this.issueId,
    required this.title,
    required this.description,
    required this.category,
    required this.reportedBy,
    required this.reporterName,
    required this.reporterEmail,
    required this.issueLocation,
    required this.reporterRegisteredLocation,
    required this.isReportedFromDifferentDistrict,
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
    this.specificLocation,
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
      'issueLocation': issueLocation.toJson(),
      'reporterRegisteredLocation': reporterRegisteredLocation.toJson(),
      'isReportedFromDifferentDistrict': isReportedFromDifferentDistrict,
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
      if (specificLocation != null) 'specificLocation': specificLocation,
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
      issueLocation: Location.fromJson(
        json['issueLocation'] as Map<String, dynamic>,
      ),
      reporterRegisteredLocation: Location.fromJson(
        json['reporterRegisteredLocation'] as Map<String, dynamic>,
      ),
      isReportedFromDifferentDistrict:
          json['isReportedFromDifferentDistrict'] as bool? ?? false,
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
      specificLocation: json['specificLocation'] as String?,
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
    Location? issueLocation,
    Location? reporterRegisteredLocation,
    bool? isReportedFromDifferentDistrict,
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
    String? specificLocation,
  }) {
    return IssueModel(
      issueId: issueId ?? this.issueId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      reportedBy: reportedBy ?? this.reportedBy,
      reporterName: reporterName ?? this.reporterName,
      reporterEmail: reporterEmail ?? this.reporterEmail,
      issueLocation: issueLocation ?? this.issueLocation,
      reporterRegisteredLocation:
          reporterRegisteredLocation ?? this.reporterRegisteredLocation,
      isReportedFromDifferentDistrict:
          isReportedFromDifferentDistrict ??
          this.isReportedFromDifferentDistrict,
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
      specificLocation: specificLocation ?? this.specificLocation,
    );
  }

  // Helper method to get time ago
  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
