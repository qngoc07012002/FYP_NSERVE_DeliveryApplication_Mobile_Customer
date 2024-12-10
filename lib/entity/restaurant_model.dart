import 'category_model.dart';
import 'location_model.dart';
import 'user_model.dart';

class Restaurant {
  String? id;
  User? owner;
  String? restaurantName;
  String? description;
  String? address;
  String? status;
  double? rating;
  String? imgUrl;
  Location? location;
  Category? category;

  Restaurant({
    this.id,
    this.owner,
    this.restaurantName,
    this.description,
    this.address,
    this.status,
    this.rating,
    this.imgUrl,
    this.location,
    this.category,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      owner: json['owner'] != null ? User.fromJson(json['owner']) : null,
      restaurantName: json['restaurantName'],
      description: json['description'],
      address: json['address'],
      status: json['status'],
      rating: json['rating'] != null ? json['rating'].toDouble() : 0.0,  // Kiểm tra rating có null không
      imgUrl: json['imgUrl'],
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,

    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner': owner?.toJson(),
      'restaurantName': restaurantName,
      'description': description,
      'address': address,
      'status': status,
      'rating': rating,
      'imgUrl': imgUrl,
      'location': location?.toJson(),
      'category': category?.toJson(),
    };
  }
}


