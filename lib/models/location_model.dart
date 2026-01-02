// lib/models/location_model.dart

class Location {
  final String district;
  final String municipality;
  final int ward;
  final String? specificLocation;
  final double? latitude;
  final double? longitude;

  Location({
    required this.district,
    required this.municipality,
    required this.ward,
    this.specificLocation,
    this.latitude,
    this.longitude,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'district': district,
      'municipality': municipality,
      'ward': ward,
      if (specificLocation != null) 'specificLocation': specificLocation,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  // Create from Firestore document
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      district: json['district'] as String,
      municipality: json['municipality'] as String,
      ward: json['ward'] as int,
      specificLocation: json['specificLocation'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  // Get location key for statistics
  String get locationKey => '${district}_${municipality}_$ward';
  
  // Get municipality key
  String get municipalityKey => '${district}_$municipality';

  // Full address string
  String get fullAddress {
    final parts = [
      if (specificLocation != null) specificLocation,
      'Ward $ward',
      municipality,
      district,
    ];
    return parts.join(', ');
  }

  Location copyWith({
    String? district,
    String? municipality,
    int? ward,
    String? specificLocation,
    double? latitude,
    double? longitude,
  }) {
    return Location(
      district: district ?? this.district,
      municipality: municipality ?? this.municipality,
      ward: ward ?? this.ward,
      specificLocation: specificLocation ?? this.specificLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}