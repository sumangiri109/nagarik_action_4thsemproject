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
    'Achham',
    'Arghakhanchi',
    'Baglung',
    'Baitadi',
    'Bajhang',
    'Bajura',
    'Banke',
    'Bara',
    'Bardiya',
    'Bhaktapur',
    'Bhojpur',
    'Chitwan',
    'Dadeldhura',
    'Dailekh',
    'Dang',
    'Darchula',
    'Dhading',
    'Dhankuta',
    'Dhanusa',
    'Dolakha',
    'Dolpa',
    'Doti',
    'Gorkha',
    'Gulmi',
    'Humla',
    'Ilam',
    'Jajarkot',
    'Jhapa',
    'Jumla',
    'Kailali',
    'Kalikot',
    'Kanchanpur',
    'Kapilvastu',
    'Kaski',
    'Kathmandu',
    'Kavrepalanchok',
    'Khotang',
    'Lalitpur',
    'Lamjung',
    'Mahottari',
    'Makwanpur',
    'Manang',
    'Morang',
    'Mugu',
    'Mustang',
    'Myagdi',
    'Nawalparasi East',
    'Nawalparasi West',
    'Nuwakot',
    'Okhaldhunga',
    'Palpa',
    'Panchthar',
    'Parbat',
    'Parsa',
    'Pyuthan',
    'Ramechhap',
    'Rasuwa',
    'Rautahat',
    'Rolpa',
    'Rukum East',
    'Rukum West',
    'Rupandehi',
    'Salyan',
    'Sankhuwasabha',
    'Saptari',
    'Sarlahi',
    'Sindhuli',
    'Sindhupalchok',
    'Siraha',
    'Solukhumbu',
    'Sunsari',
    'Surkhet',
    'Syangja',
    'Tanahu',
    'Taplejung',
    'Terhathum',
    'Udayapur',
  ];

  /// Get municipalities for a district
  static Map<String, List<String>> getMunicipalitiesByDistrict() {
    return {
      // Bagmati Province
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
      'Kavrepalanchok': [
        'Dhulikhel Municipality',
        'Banepa Municipality',
        'Panauti Municipality',
        'Panchkhal Municipality',
        'Namobuddha Municipality',
        'Mandan Deupur Municipality',
        'Khanikhola Gaupalika',
        'Chauri Deurali Gaupalika',
        'Temal Gaupalika',
        'Bethanchok Gaupalika',
        'Bhumlu Gaupalika',
        'Mahabharat Gaupalika',
        'Roshi Gaupalika',
      ],
      'Dhading': [
        'Nilkantha Municipality',
        'Dhunibesi Municipality',
        'Khaniyabas Gaupalika',
        'Gajuri Gaupalika',
        'Galchhi Gaupalika',
        'Gangajamuna Gaupalika',
        'Jwalamukhi Gaupalika',
        'Thakre Gaupalika',
        'Netrawati Gaupalika',
        'Benighat Rorang Gaupalika',
        'Ruby Valley Gaupalika',
        'Siddhalek Gaupalika',
        'Tripurasundari Gaupalika',
      ],
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
      'Makwanpur': [
        'Hetauda Sub-Metropolitan City',
        'Thaha Municipality',
        'Indrasarowar Gaupalika',
        'Kailash Gaupalika',
        'Bakaiya Gaupalika',
        'Bagmati Gaupalika',
        'Bhimphedi Gaupalika',
        'Makawanpurgadhi Gaupalika',
        'Manahari Gaupalika',
        'Raksirang Gaupalika',
      ],
      'Nuwakot': [
        'Bidur Municipality',
        'Belkotgadhi Municipality',
        'Kakani Gaupalika',
        'Kispang Gaupalika',
        'Myagang Gaupalika',
        'Shivapuri Gaupalika',
        'Panchakanya Gaupalika',
        'Likhu Gaupalika',
        'Dupcheshwar Gaupalika',
        'Suryagadhi Gaupalika',
        'Tadi Gaupalika',
        'Tarkeshwar Gaupalika',
      ],
      'Rasuwa': [
        'Uttargaya Gaupalika',
        'Kalika Gaupalika',
        'Gosaikunda Gaupalika',
        'Naukunda Gaupalika',
        'Parbatikunda Gaupalika',
      ],
      'Sindhupalchok': [
        'Chautara Sangachokgadhi Municipality',
        'Barhabise Municipality',
        'Melamchi Municipality',
        'Bahrabise Municipality',
        'Jugal Gaupalika',
        'Panchpokhari Thangpal Gaupalika',
        'Balephi Gaupalika',
        'Sunkoshi Gaupalika',
        'Indrawati Gaupalika',
        'Tripurasundari Gaupalika',
        'Helambu Gaupalika',
        'Lisankhu Pakhar Gaupalika',
      ],
      'Chitwan': [
        'Bharatpur Metropolitan City',
        'Kalika Municipality',
        'Khairahani Municipality',
        'Madi Municipality',
        'Ratnanagar Municipality',
        'Rapti Municipality',
        'Ichchhakamana Gaupalika',
      ],

      // Gandaki Province
      'Kaski': [
        'Pokhara Metropolitan City',
        'Annapurna Gaupalika',
        'Machhapuchchhre Gaupalika',
        'Madi Gaupalika',
        'Rupa Gaupalika',
      ],
      'Lamjung': [
        'Besisahar Municipality',
        'Dordi Gaupalika',
        'Dudhpokhari Gaupalika',
        'Kwhlosothar Gaupalika',
        'Madhya Nepal Municipality',
        'Marsyangdi Gaupalika',
        'Rainas Municipality',
        'Sundarbazar Municipality',
      ],
      'Tanahu': [
        'Bhanu Municipality',
        'Bhimad Municipality',
        'Byas Municipality',
        'Shuklagandaki Municipality',
        'Anbukhaireni Gaupalika',
        'Devghat Gaupalika',
        'Bandipur Gaupalika',
        'Ghiring Gaupalika',
        'Myagde Gaupalika',
        'Rhishing Gaupalika',
      ],
      'Baglung': [
        'Baglung Municipality',
        'Dhorpatan Municipality',
        'Galkot Municipality',
        'Jaimuni Municipality',
        'Bareng Gaupalika',
        'Badigad Gaupalika',
        'Nisikhola Gaupalika',
        'Kanthekhola Gaupalika',
        'Taman Khola Gaupalika',
        'Tarakhola Gaupalika',
      ],
      'Parbat': [
        'Kushma Municipality',
        'Phalebas Municipality',
        'Jaljala Gaupalika',
        'Paiyun Gaupalika',
        'Mahashila Gaupalika',
        'Modi Gaupalika',
        'Bihadi Gaupalika',
      ],
      'Syangja': [
        'Galyang Municipality',
        'Chapakot Municipality',
        'Putalibazar Municipality',
        'Bhirkot Municipality',
        'Waling Municipality',
        'Arjunchaupari Gaupalika',
        'Aandhikhola Gaupalika',
        'Kaligandaki Gaupalika',
        'Phedikhola Gaupalika',
        'Harinas Gaupalika',
        'Biruwa Gaupalika',
      ],
      'Myagdi': [
        'Beni Municipality',
        'Annapurna Gaupalika',
        'Dhaulagiri Gaupalika',
        'Mangala Gaupalika',
        'Malika Gaupalika',
        'Raghuganga Gaupalika',
      ],
      'Mustang': [
        'Gharpajhong Gaupalika',
        'Thasang Gaupalika',
        'Dalome Gaupalika',
        'Lo-Manthang Gaupalika',
        'Barhagaun Muktichhetra Gaupalika',
      ],
      'Manang': [
        'Chame Gaupalika',
        'Nason Gaupalika',
        'Narfu Gaupalika',
        'Manang Ngisyang Gaupalika',
      ],
      'Nawalparasi West': [
        'Bardaghat Municipality',
        'Ramgram Municipality',
        'Sunwal Municipality',
        'Susta Gaupalika',
        'Palhinandan Gaupalika',
        'Pratappur Gaupalika',
        'Sarawal Gaupalika',
      ],

      // Lumbini Province
      'Rupandehi': [
        'Butwal Sub-Metropolitan City',
        'Devdaha Municipality',
        'Lumbini Sanskritik Municipality',
        'Sainamaina Municipality',
        'Siddharthanagar Municipality',
        'Tilottama Municipality',
        'Gaidahawa Gaupalika',
        'Kanchan Gaupalika',
        'Kotahimai Gaupalika',
        'Marchawari Gaupalika',
        'Mayadevi Gaupalika',
        'Omsatiya Gaupalika',
        'Rohini Gaupalika',
        'Sammarimai Gaupalika',
        'Siyari Gaupalika',
        'Suddhodhan Gaupalika',
      ],
      'Kapilvastu': [
        'Kapilvastu Municipality',
        'Banganga Municipality',
        'Buddhabhumi Municipality',
        'Shivaraj Municipality',
        'Krishnanagar Municipality',
        'Maharajgunj Municipality',
        'Yashodhara Gaupalika',
        'Bijaynagar Gaupalika',
        'Mayadevi Gaupalika',
        'Suddhodhan Gaupalika',
      ],
      'Banke': [
        'Nepalgunj Sub-Metropolitan City',
        'Kohalpur Municipality',
        'Rapti Sonari Gaupalika',
        'Narainapur Gaupalika',
        'Duduwa Gaupalika',
        'Janaki Gaupalika',
        'Khajura Gaupalika',
        'Baijanath Gaupalika',
      ],
      'Bardiya': [
        'Gulariya Municipality',
        'Madhuwan Municipality',
        'Rajapur Municipality',
        'Thakurbaba Municipality',
        'Bansgadhi Municipality',
        'Barbardiya Municipality',
        'Badhaiyatal Gaupalika',
        'Geruwa Gaupalika',
      ],
      'Dang': [
        'Ghorahi Sub-Metropolitan City',
        'Tulsipur Sub-Metropolitan City',
        'Lamahi Municipality',
        'Gadhawa Gaupalika',
        'Rajpur Gaupalika',
        'Shantinagar Gaupalika',
        'Rapti Gaupalika',
        'Banglachuli Gaupalika',
        'Dangisharan Gaupalika',
        'Babai Gaupalika',
      ],
      'Palpa': [
        'Tansen Municipality',
        'Rampur Municipality',
        'Rainadevi Chhahara Gaupalika',
        'Ribdikot Gaupalika',
        'Purbakhola Gaupalika',
        'Rambha Gaupalika',
        'Tinau Gaupalika',
        'Nisdi Gaupalika',
        'Mathagadhi Gaupalika',
        'Bagnaskali Gaupalika',
      ],

      // For other districts, provide default municipalities
      // You can add more as needed
    };
  }

  /// Get number of wards for a municipality (default 9 for most)
  static int getWardCount(String municipality) {
    // Metropolitan cities have more wards
    if (municipality.contains('Metropolitan')) {
      if (municipality == 'Kathmandu Metropolitan City') return 32;
      if (municipality == 'Lalitpur Metropolitan City') return 29;
      if (municipality == 'Pokhara Metropolitan City') return 33;
      if (municipality == 'Bharatpur Metropolitan City') return 29;
      if (municipality == 'Birgunj Metropolitan City') return 32;
      if (municipality == 'Biratnagar Metropolitan City') return 19;
      return 20; // Default for other metros
    }

    // Sub-metropolitan cities
    if (municipality.contains('Sub-Metropolitan')) {
      return 15; // Default for sub-metros
    }

    // Regular municipalities and gaunpalikas
    return 9; // Default
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
  static const List<String> allowedCertificateExtensions = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
  ];

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
  static const String permissionError =
      'You don\'t have permission to perform this action';
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

  static const String verificationPending =
      'Your account is pending verification. You will be notified once approved.';
  static const String verificationApproved =
      'Your account has been verified! You can now manage issues.';
  static const String verificationRejected =
      'Your verification request was rejected.';
}
