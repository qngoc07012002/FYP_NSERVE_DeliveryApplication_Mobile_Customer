class OrderItem {
  String? foodId;
  String? foodName;
  int? quantity;
  double? totalPrice;

  OrderItem({
    this.foodId,
    this.foodName,
    this.quantity,
    this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      foodId: json['foodId'] ?? '',
      foodName: json['foodName'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalPrice: json['totalPrice'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
