import 'Category.dart';
import 'Restaurant.dart';

class Food {
  String? id;
  String name;
  String imageUrl;
  String description;
  int quantity;
  bool isAvailable;
  double price;

  Food(this.id, this.name, this.imageUrl, this.description, this.quantity, this.isAvailable, this.price, );

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      json['id'] as String?,
      json['name'] as String,
      json['imgUrl'] as String,
      json['description'] as String,
      json['quantity'] ?? 0,
      json['status'] == 'ACTIVE',
      json['price'] as double,
    );
  }
}