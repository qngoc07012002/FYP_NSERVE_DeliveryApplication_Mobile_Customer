class Location {
  String? id;
  double? longitude;
  double? latitude;
  String? address;

  Location({
    this.id,
    this.longitude,
    this.latitude,
    this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'longitude': longitude,
      'latitude': latitude,
      'address': address,
    };
  }
}
