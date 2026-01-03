// lib/utils/constants.dart

class AppConstants {
  // App Info
  static const String appName = 'Nagarik Action';
  static const String appVersion = '1.0.0';

  // ============================================================
  // NEPAL LOCATIONS DATA
  // ============================================================

  /// List of all districts in Nepal
  static const List<String> districts = [
    'Achham', 'Arghakhanchi', 'Baglung', 'Baitadi', 'Bajhang', 'Bajura',
    'Banke', 'Bara', 'Bardiya', 'Bhaktapur', 'Bhojpur', 'Chitwan',
    'Dadeldhura', 'Dailekh', 'Dang', 'Darchula', 'Dhading', 'Dhankuta',
    'Dhanusa', 'Dolakha', 'Dolpa', 'Doti', 'Gorkha', 'Gulmi',
    'Humla', 'Ilam', 'Jajarkot', 'Jhapa', 'Jumla', 'Kailali',
    'Kalikot', 'Kanchanpur', 'Kapilvastu', 'Kaski', 'Kathmandu', 'Kavrepalanchok',
    'Khotang', 'Lalitpur', 'Lamjung', 'Mahottari', 'Makwanpur', 'Manang',
    'Morang', 'Mugu', 'Mustang', 'Myagdi', 'Nawalparasi East', 'Nawalparasi West',
    'Nuwakot', 'Okhaldhunga', 'Palpa', 'Panchthar', 'Parbat', 'Parsa',
    'Pyuthan', 'Ramechhap', 'Rasuwa', 'Rautahat', 'Rolpa', 'Rukum East',
    'Rukum West', 'Rupandehi', 'Salyan', 'Sankhuwasabha', 'Saptari', 'Sarlahi',
    'Sindhuli', 'Sindhupalchok', 'Siraha', 'Solukhumbu', 'Sunsari', 'Surkhet',
    'Syangja', 'Tanahu', 'Taplejung', 'Terhathum', 'Udayapur',
  ];

  /// Get municipalities for a district
  /// Note: This is a simplified version. In production, you should have
  /// a complete database of all municipalities for each district.
  static Map<String, List<String>> getMunicipalitiesByDistrict() {
    return {
      'Gorkha': [
        'Gorkha Municipality',
        'Palungtar Municipality',
        'Sulikot Gaupalika',
        'Siranchok Gaupalika',
        'Ajirkot Gaupalika',
        'Tsum Nubri Gaupalika',
        'Dharche Gaupalika',
        'Bhimsen Gaupalika',
        'Sahid Lakhan Gaupalika',
        'Aarughat Gaupalika',
        'Gandaki Gaupalika',
      ],
      'Kathmandu': [
        'Kathmandu Metropolitan City',
        'Budhanilkantha Municipality',
        'Chandragiri Municipality',
        'Dakshinkali Municipality',
        'Gokarneshwor Municipality',
        'Kageshwori Manohara Municipality',
        'Kirtipur Municipality',
        'Nagarjun Municipality',
        'Shankharapur Municipality',
        'Tarakeshwor Municipality',
        'Tokha Municipality',
      ],
      'Lalitpur': [
        'Lalitpur Metropolitan City',
        'Godawari Municipality',
        'Mahalaxmi Municipality',
        'Konjyosom Gaupalika',
        'Bagmati Gaupalika',
        'Mahankal Gaupalika',
      ],
      'Bhaktapur': [
        'Bhaktapur Municipality',
        'Changunarayan Municipality',
        'Madhyapur Thimi Municipality',
        'Suryabinayak Municipality',
      ],
      // Add more districts as needed...
      // For now, return empty list for other districts
    };
  }

  /// Get number of wards for a municipality
  /// Note: This should be dynamic based on actual data
  static int getWardCount(String municipality) {
    // Most municipalities have 9 wards, but some have more
    // Kathmandu has 32 wards, for example
    if (municipality == 'Kathmandu Metropolitan City') {
      return 32;
    } else if (municipality == 'Lalitpur Metropolitan City') {
      return 29;
    } else if (municipality == 'Pokhara Metropolitan City') {
      return 33;
    } else {
      return 9; // Default for most municipalities
    }
  }

  // ============================================================
  // ISSUE CATEGORIES
  // ============================================================

  static const List<String> issueCategories = [
    'Infrastructure',
    'Water',
    'Electricity',
    'Sanitation',
    'Health',
    'Education',
    'Other',
  ];

  // ============================================================
  // ISSUE PRIORITIES
  // ============================================================

  static const List<String> issuePriorities = [
    'Low',
    'Medium',
    'High',
    'Urgent',
  ];

  // ============================================================
  // GOVERNMENT POSITIONS
  // ============================================================

  static const List<String> governmentPositions = [
    'Ward Chairperson',
    'Ward Secretary',
    'Ward Member',
    'Municipality Mayor',
    'Municipality Deputy Mayor',
    'Municipality Chief Administrative Officer',
    'Department Head',
    'Officer',
    'Engineer',
    'Other',
  ];

  // ============================================================
  // GOVERNMENT DEPARTMENTS
  // ============================================================

  static const List<String> governmentDepartments = [
    'Administration',
    'Public Works',
    'Infrastructure',
    'Water Supply',
    'Electricity',
    'Health',
    'Education',
    'Sanitation',
    'Finance',
    'Planning',
    'Other',
  ];

  // ============================================================
  // FILE UPLOAD LIMITS
  // ============================================================

  static const int maxImageSizeMB = 5;
  static const int maxCertificateSizeMB = 10;
  static const int maxImagesPerIssue = 5;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png'];
  static const List<String> allowedCertificateExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

  // ============================================================
  // PAGINATION
  // ============================================================

  static const int issuesPerPage = 20;
  static const int commentsPerPage = 10;

  // ============================================================
  // ERROR MESSAGES
  // ============================================================

  static const String networkError = 'Please check your internet connection';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String permissionError = 'You don\'t have permission to perform this action';
  static const String uploadError = 'Failed to upload file. Please try again.';

  // ============================================================
  // SUCCESS MESSAGES
  // ============================================================

  static const String signupSuccess = 'Account created successfully!';
  static const String loginSuccess = 'Logged in successfully!';
  static const String issueReportedSuccess = 'Issue reported successfully!';
  static const String commentAddedSuccess = 'Comment added successfully!';
  static const String profileUpdatedSuccess = 'Profile updated successfully!';

  // ============================================================
  // VERIFICATION MESSAGES
  // ============================================================

  static const String verificationPending = 'Your account is pending verification. You will be notified once approved.';
  static const String verificationApproved = 'Your account has been verified! You can now manage issues.';
  static const String verificationRejected = 'Your verification request was rejected.';
}