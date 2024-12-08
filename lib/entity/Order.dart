import 'package:intl/intl.dart'; // For date formatting and parsing
import 'Location.dart';
import 'OrderItem.dart';
import 'Restaurant.dart';
import 'User.dart';

class Order {
  String? id;
  String? orderCode;
  String? orderType;
  RestaurantInfo? restaurantInfo;
  DriverInfo? driverInfo;
  Location? startLocation;
  Location? endLocation;
  String? orderStatus;
  double? shippingFee;
  double? totalPrice;
  DateTime? createdAt;
  List<OrderItem>? orderItems;

  Order({
    this.id,
    this.orderCode,
    this.orderType,
    this.restaurantInfo,
    this.driverInfo,
    this.startLocation,
    this.endLocation,
    this.orderStatus,
    this.shippingFee,
    this.totalPrice,
    this.createdAt,
    this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var orderItemsJson = json['orderItems'] as List<dynamic>? ?? [];
    List<OrderItem> orderItemsList = orderItemsJson.map((itemJson) => OrderItem.fromJson(itemJson)).toList();

    String? dateString = json['createdAt'];
    DateTime? createdAt;
    if (dateString != null) {
      try {
        createdAt = DateTime.parse(dateString).toLocal();
      } catch (e) {
        createdAt = null;
      }
    }

    return Order(
      id: json['id'],
      orderCode: json['orderCode'],
      orderType: json['orderType'],
      restaurantInfo: json['restaurantInfo'] != null
          ? RestaurantInfo.fromJson(json['restaurantInfo'])
          : null,
      driverInfo: json['driverInfo'] != null
          ? DriverInfo.fromJson(json['driverInfo'])
          : null,
      startLocation: json['startLocation'] != null
          ? Location.fromJson(json['startLocation'])
          : null,
      endLocation: json['endLocation'] != null
          ? Location.fromJson(json['endLocation'])
          : null,
      orderStatus: json['orderStatus'],
      shippingFee: json['shippingFee'] != null ? json['shippingFee'] : 0.0,
      totalPrice: json['totalPrice'] != null ? json['totalPrice'] : 0.0,
      createdAt: createdAt,
      orderItems: orderItemsList.isNotEmpty ? orderItemsList : null,
    );
  }

  String get formattedCreatedAt {
    return createdAt != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt!) : 'N/A';
  }
}

class RestaurantInfo {
  final String? name;
  final String? img;
  final String? restaurantLocation;

  RestaurantInfo({
    this.name,
    this.img,
    this.restaurantLocation,
  });

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) {
    return RestaurantInfo(
      name: json['name'],
      img: json['img'],
      restaurantLocation: json['restaurantLocation'],
    );
  }
}

class DriverInfo {
  final String? name;
  final String? img;
  final String? phoneNumber;

  DriverInfo({
    this.name,
    this.img,
    this.phoneNumber,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      name: json['name'],
      img: json['img'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
