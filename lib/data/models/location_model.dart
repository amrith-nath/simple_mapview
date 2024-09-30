class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel({
    required this.latitude,
    required this.longitude,
  });

  LocationModel copyWith({
    double? latitude,
    double? longitude,
  }) =>
      LocationModel(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  // fromJson method
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}
