import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/order_controller.dart';
import '../ultilities/Constant.dart';
import 'orderdetail_screen.dart';

class OrderPage extends StatelessWidget {
  final OrderController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.orders.isEmpty) {
          return const Center(child: Text('No orders found'));
        }
        return ListView.builder(
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
              return GestureDetector(
                onTap: () {
                  controller.currentOrder.value = order;
                  Get.to(OrderDetailPage());
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Phần hình ảnh
                      if (order.orderType == 'FOOD' && order.restaurantInfo != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            Constant.BACKEND_URL + order.restaurantInfo!.img!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/food_image.png', width: 80, height: 80, fit: BoxFit.cover);
                            },
                          ),
                        )
                      else
                        const Icon(
                          Icons.directions_car,
                          size: 80,
                          color: Color(0xFF39c5c8),
                        ),
                      const SizedBox(width: 16.0),

                      // Phần thông tin
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (order.orderType == 'FOOD') ...[
                                    // Hiển thị thông tin FOOD
                                    Text(
                                      order.restaurantInfo?.name ?? 'Unknown Restaurant',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                    ),
                                    const SizedBox(height: 4.0),
                                  ],
                                  // Hiển thị chung cho cả FOOD và RIDE
                                  Text(
                                    'Order Code: ${order.orderCode}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Status: ${order.orderStatus}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'Fee: \$${order.shippingFee?.toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

          },
        );
      }),
    );
  }
}