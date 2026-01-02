// lib/models/enums.dart

enum UserRole {
  citizen,
  government,
  admin;

  String toJson() => name;

  static UserRole fromJson(String json) {
    return UserRole.values.firstWhere((e) => e.name == json);
  }
}

enum VerificationStatus {
  pending,
  approved,
  rejected;

  String toJson() => name;

  static VerificationStatus fromJson(String json) {
    return VerificationStatus.values.firstWhere((e) => e.name == json);
  }
}

enum IssueStatus {
  not_started,
  in_progress,
  completed;

  String toJson() => name;

  static IssueStatus fromJson(String json) {
    return IssueStatus.values.firstWhere((e) => e.name == json);
  }

  String get displayName {
    switch (this) {
      case IssueStatus.not_started:
        return 'Not Started';
      case IssueStatus.in_progress:
        return 'In Progress';
      case IssueStatus.completed:
        return 'Completed';
    }
  }
}

enum IssueCategory {
  infrastructure,
  water,
  electricity,
  sanitation,
  health,
  education,
  other;

  String toJson() => name;

  static IssueCategory fromJson(String json) {
    return IssueCategory.values.firstWhere((e) => e.name == json);
  }

  String get displayName {
    switch (this) {
      case IssueCategory.infrastructure:
        return 'Infrastructure';
      case IssueCategory.water:
        return 'Water';
      case IssueCategory.electricity:
        return 'Electricity';
      case IssueCategory.sanitation:
        return 'Sanitation';
      case IssueCategory.health:
        return 'Health';
      case IssueCategory.education:
        return 'Education';
      case IssueCategory.other:
        return 'Other';
    }
  }
}

enum IssuePriority {
  low,
  medium,
  high,
  urgent;

  String toJson() => name;

  static IssuePriority fromJson(String json) {
    return IssuePriority.values.firstWhere((e) => e.name == json);
  }

  String get displayName {
    switch (this) {
      case IssuePriority.low:
        return 'Low';
      case IssuePriority.medium:
        return 'Medium';
      case IssuePriority.high:
        return 'High';
      case IssuePriority.urgent:
        return 'Urgent';
    }
  }
}

enum ReactionType {
  support,
  concern,
  angry,
  sad;

  String toJson() => name;

  static ReactionType fromJson(String json) {
    return ReactionType.values.firstWhere((e) => e.name == json);
  }

  String get emoji {
    switch (this) {
      case ReactionType.support:
        return '👍';
      case ReactionType.concern:
        return '😟';
      case ReactionType.angry:
        return '😠';
      case ReactionType.sad:
        return '😢';
    }
  }
}

enum NotificationType {
  status_update,
  new_comment,
  new_reaction,
  verification_approved,
  verification_rejected,
  issue_resolved,
  mention;

  String toJson() => name;

  static NotificationType fromJson(String json) {
    return NotificationType.values.firstWhere((e) => e.name == json);
  }
}
