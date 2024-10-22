class RestaurantResponse {
  final String id;
  final String restaurantName;
  final String description;
  final String address;
  final String imgUrl;
  final double rating;

  RestaurantResponse({
    required this.id,
    required this.restaurantName,
    required this.description,
    required this.address,
    required this.imgUrl,
    required this.rating,
  });

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantResponse(
      id: json['id'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

}

