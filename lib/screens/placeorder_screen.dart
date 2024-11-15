import 'package:deliveryapplication_mobile_customer/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';

class OrderSummaryPage extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();  // Accessing the controller
  final HomeController homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    orderController.calculateShippingFee();
    print(orderController.restaurant.value?.restaurantName);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF39c5c8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => {
            orderController.clearOrder(),
            Navigator.pop(context)
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Section
              GestureDetector(
                onTap: () => homeController.pickLocation((address, lat, lng) {
                  homeController.selectedLocation.value = address;
                  orderController.calculateShippingFee();
                }),
                child: Obx(() {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xFF39c5c8)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(homeController.selectedLocation.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const Icon(Icons.edit, color: Color(0xFF39c5c8)),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24.0),

              // Order Summary
              Obx(() {
                double totalAmount = orderController.totalAmount.value;
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12.0),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: orderController.selectedFoods.length,
                        itemBuilder: (context, index) {
                          final item = orderController.selectedFoods[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Tên món ăn
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Số lượng món ăn
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'x${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // Tổng giá tiền
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Distance', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${orderController.distance.value.toStringAsFixed(2)} km'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shipping Fee', style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('\$${orderController.shippingFee.value.toStringAsFixed(2)}'),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('\$${(totalAmount + orderController.shippingFee.value).toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24.0),

              // Payment Method
              GestureDetector(
                onTap: () {
                  // Logic for selecting payment method
                },
                child: Obx(() {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          orderController.selectedPaymentMethod.value == 'Cash'
                              ? Icons.money_off
                              : orderController.selectedPaymentMethod.value == 'Visa'
                              ? Icons.credit_card
                              : Icons.paypal,
                          color: Color(0xFF39c5c8),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(orderController.selectedPaymentMethod.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const Icon(Icons.arrow_drop_down, color: Color(0xFF39c5c8)),
                      ],
                    ),
                  );
                }),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Logic to place the order
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF39c5c8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: Text('Place Order', style: const TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),

    );
  }
}
