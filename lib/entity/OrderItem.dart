class OrderItem {
  String? foodName;
  int? quantity;
  double? totalPrice;

  OrderItem({
    this.foodName,
    this.quantity,
    this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      foodName: json['foodName'],
      quantity: json['quantity'],
      totalPrice: json['totalPrice']?.toDouble(),
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
