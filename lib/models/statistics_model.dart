// lib/models/statistics_models.dart

import 'location_model.dart';

class StatusCounts {
  final int notStarted;
  final int inProgress;
  final int completed;

  StatusCounts({
    required this.notStarted,
    required this.inProgress,
    required this.completed,
  });

  Map<String, dynamic> toJson() {
    return {
      'notStarted': notStarted,
      'inProgress': inProgress,
      'completed': completed,
    };
  }

  factory StatusCounts.fromJson(Map<String, dynamic> json) {
    return StatusCounts(
      notStarted: json['notStarted'] as int? ?? 0,
      inProgress: json['inProgress'] as int? ?? 0,
      completed: json['completed'] as int? ?? 0,
    );
  }
}

class MonthlyData {
  final String month;
  final int reported;
  final int resolved;

  MonthlyData({
    required this.month,
    required this.reported,
    required this.resolved,
  });

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'reported': reported,
      'resolved': resolved,
    };
  }

  factory MonthlyData.fromJson(Map<String, dynamic> json) {
    return MonthlyData(
      month: json['month'] as String,
      reported: json['reported'] as int? ?? 0,
      resolved: json['resolved'] as int? ?? 0,
    );
  }
}

class TopIssue {
  final String issueId;
  final String title;
  final int count;

  TopIssue({
    required this.issueId,
    required this.title,
    required this.count,
  });

  Map<String, dynamic> toJson() {
    return {
      'issueId': issueId,
      'title': title,
      'reactionsCount': count, // or 'commentsCount'
    };
  }

  factory TopIssue.fromJson(Map<String, dynamic> json) {
    return TopIssue(
      issueId: json['issueId'] as String,
      title: json['title'] as String,
      count: (json['reactionsCount'] ?? json['commentsCount']) as int? ?? 0,
    );
  }
}

class WardStatistics {
  final String locationKey;
  final Location location;
  final int totalIssues;
  final int activeIssues;
  final int resolvedIssues;
  final StatusCounts statusCounts;
  final Map<String, int> categoryCounts;
  final Map<String, int> priorityCounts;
  final List<MonthlyData> monthlyData;
  final int totalComments;
  final int totalReactions;
  final int totalViews;
  final double resolutionRate;
  final double responseRate;
  final double averageResolutionDays;
  final List<TopIssue> topIssuesByReactions;
  final List<TopIssue> topIssuesByComments;
  final DateTime lastUpdated;

  WardStatistics({
    required this.locationKey,
    required this.location,
    required this.totalIssues,
    required this.activeIssues,
    required this.resolvedIssues,
    required this.statusCounts,
    required this.categoryCounts,
    required this.priorityCounts,
    required this.monthlyData,
    required this.totalComments,
    required this.totalReactions,
    required this.totalViews,
    required this.resolutionRate,
    required this.responseRate,
    required this.averageResolutionDays,
    required this.topIssuesByReactions,
    required this.topIssuesByComments,
    required this.lastUpdated,
  });

  factory WardStatistics.fromJson(Map<String, dynamic> json) {
    return WardStatistics(
      locationKey: json['locationKey'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      totalIssues: json['totalIssues'] as int? ?? 0,
      activeIssues: json['activeIssues'] as int? ?? 0,
      resolvedIssues: json['resolvedIssues'] as int? ?? 0,
      statusCounts: StatusCounts.fromJson(
          json['statusCounts'] as Map<String, dynamic>? ?? {}),
      categoryCounts: Map<String, int>.from(json['categoryCounts'] ?? {}),
      priorityCounts: Map<String, int>.from(json['priorityCounts'] ?? {}),
      monthlyData: (json['monthlyData'] as List<dynamic>?)
              ?.map((e) => MonthlyData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalComments: json['totalComments'] as int? ?? 0,
      totalReactions: json['totalReactions'] as int? ?? 0,
      totalViews: json['totalViews'] as int? ?? 0,
      resolutionRate: (json['resolutionRate'] as num?)?.toDouble() ?? 0.0,
      responseRate: (json['responseRate'] as num?)?.toDouble() ?? 0.0,
      averageResolutionDays:
          (json['averageResolutionDays'] as num?)?.toDouble() ?? 0.0,
      topIssuesByReactions: (json['topIssuesByReactions'] as List<dynamic>?)
              ?.map((e) => TopIssue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topIssuesByComments: (json['topIssuesByComments'] as List<dynamic>?)
              ?.map((e) => TopIssue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdated: (json['lastUpdated'] as dynamic).toDate(),
    );
  }
}