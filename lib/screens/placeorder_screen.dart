import 'package:deliveryapplication_mobile_customer/controller/home_controller.dart';
import 'package:deliveryapplication_mobile_customer/screens/orderprocessing_screen.dart';
import 'package:deliveryapplication_mobile_customer/services/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final OrderController orderController = Get.find();  // Accessing the controller
  final HomeController homeController = Get.find();
  String _selectedPaymentMethod = 'Cash';
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
              // Payment Method
              GestureDetector(
                onTap: _selectPaymentMethod,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedPaymentMethod == 'Cash'
                            ? Icons.money_off
                            : Icons.credit_card,
                        color: Color(0xFF39c5c8),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(_selectedPaymentMethod, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Color(0xFF39c5c8)),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
           if (_selectedPaymentMethod == "Cash") {
             orderController.sendOrderFoodRequest();
           //  Get.to(OrderProcessingPage());
             Get.to(() => OrderProcessingPage());
           } else  if (await StripeService.instance.makePayment()){
             orderController.sendOrderFoodRequest();
             Get.to(() => OrderProcessingPage());
           }

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

  void _selectPaymentMethod() {
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              leading: Icon(Icons.money_off, color: Colors.black),
              title: Text('Cash'),
              onTap: () => Navigator.pop(context, 'Cash'),
            ),
            ListTile(
              leading: Icon(Icons.credit_card, color: Colors.black),
              title: Text('Credit'),
              onTap: () => Navigator.pop(context, 'Credit'),
            ),
          ],
        );
      },
    ).then((selected) {
      if (selected != null) {
        setState(() {
          _selectedPaymentMethod = selected;
        });
      }
    });
  }
}

