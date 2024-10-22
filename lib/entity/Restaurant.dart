import 'Location.dart';
import 'User.dart';

class Restaurant {
  String id;
  User owner;
  String restaurantName;
  String address;
  double rating;
  String imgUrl;
  Location location;

  Restaurant({
    required this.id,
    required this.owner,
    required this.restaurantName,
    required this.address,
    required this.rating,
    required this.imgUrl,
    required this.location,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      owner: User.fromJson(json['owner']),
      restaurantName: json['restaurantName'],
      address: json['address'],
      rating: json['rating'].toDouble(),
      imgUrl: json['imgUrl'],
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner.toJson(),
      'restaurantName': restaurantName,
      'address': address,
      'rating': rating,
      'imgUrl': imgUrl,
      'location': location.toJson(),
    };
  }
}


