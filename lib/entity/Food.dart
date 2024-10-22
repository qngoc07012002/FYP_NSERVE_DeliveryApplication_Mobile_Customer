import 'Category.dart';
import 'Restaurant.dart';

class Food {
  String id;
  Category category;
  Restaurant restaurant;
  String name;
  String description;
  double price;
  String imgUrl;
  DateTime createAt;
  DateTime updateAt;

  Food({
    required this.id,
    required this.category,
    required this.restaurant,
    required this.name,
    required this.description,
    required this.price,
    required this.imgUrl,
    required this.createAt,
    required this.updateAt,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      category: Category.fromJson(json['category']),
      restaurant: Restaurant.fromJson(json['restaurant']),
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imgUrl: json['imgUrl'],
      createAt: DateTime.parse(json['createAt']),
      updateAt: DateTime.parse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.toJson(),
      'restaurant': restaurant.toJson(),
      'name': name,
      'description': description,
      'price': price,
      'imgUrl': imgUrl,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }
}