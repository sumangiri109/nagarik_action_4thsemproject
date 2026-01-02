// lib/models/government_details_model.dart

class GovernmentDetails {
  final String officeName;
  final String position;
  final String? department;
  final String? officeEmail;
  final String? officePhone;

  GovernmentDetails({
    required this.officeName,
    required this.position,
    this.department,
    this.officeEmail,
    this.officePhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'officeName': officeName,
      'position': position,
      if (department != null) 'department': department,
      if (officeEmail != null) 'officeEmail': officeEmail,
      if (officePhone != null) 'officePhone': officePhone,
    };
  }

  factory GovernmentDetails.fromJson(Map<String, dynamic> json) {
    return GovernmentDetails(
      officeName: json['officeName'] as String,
      position: json['position'] as String,
      department: json['department'] as String?,
      officeEmail: json['officeEmail'] as String?,
      officePhone: json['officePhone'] as String?,
    );
  }

  GovernmentDetails copyWith({
    String? officeName,
    String? position,
    String? department,
    String? officeEmail,
    String? officePhone,
  }) {
    return GovernmentDetails(
      officeName: officeName ?? this.officeName,
      position: position ?? this.position,
      department: department ?? this.department,
      officeEmail: officeEmail ?? this.officeEmail,
      officePhone: officePhone ?? this.officePhone,
    );
  }
}