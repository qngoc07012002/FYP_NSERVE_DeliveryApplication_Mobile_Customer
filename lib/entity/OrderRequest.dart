import 'package:deliveryapplication_mobile_customer/entity/Location.dart';

import 'OrderItem.dart';

class OrderRequest {
  String? restaurantId;
  Location? customerLocation;
  List<OrderItem>? orderItems;
  double? shippingFee;
  double? distance;
  double? totalPrice;
  String? orderType;
  String? paymentMethod;

  OrderRequest({
    this.restaurantId,
    this.customerLocation,
    this.orderItems,
    this.shippingFee,
    this.distance,
    this.totalPrice,
    this.orderType,
    this.paymentMethod,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) {
    return OrderRequest(
      restaurantId: json['restaurantId'],
      customerLocation: json['customerLocation'] != null
          ? Location.fromJson(json['customerLocation'])
          : null,
      orderItems: json['orderItems'] != null
          ? (json['orderItems'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList()
          : null,
      shippingFee: json['shippingFee']?.toDouble(),
      distance: json['distance']?.toDouble(),
      totalPrice: json['totalPrice']?.toDouble(),
      orderType: json['orderType'],
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'customerLocation': customerLocation?.toJson(),
      'orderItems': orderItems?.map((item) => item.toJson()).toList(),
      'shippingFee': shippingFee,
      'distance': distance,
      'totalPrice': totalPrice,
      'orderType': orderType,
      'paymentMethod': paymentMethod,
    };
  }
}


