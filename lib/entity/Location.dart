class Location {
  String? id;
  String? longitude;
  String? latitude;

  Location({
    this.id,
    this.longitude,
    this.latitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
