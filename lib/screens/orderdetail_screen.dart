import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../controller/order_controller.dart';
import '../entity/Order.dart';
import '../entity/OrderItem.dart';
import '../ultilities/Constant.dart'; // Để định dạng thời gian

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {

  final OrderController orderController = Get.find();


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Invoice',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        final currentOrder = orderController.currentOrder.value;


        if (currentOrder == null) {
          return const Center(
            child: Text(
              'No Order Details Available',
              style: TextStyle(fontSize: 18.0),
            ),
          );
        }

        final orderId = currentOrder.id;
        final orderType = currentOrder.orderType;
        final orderCode = currentOrder.orderCode;
        final shippingFee = currentOrder.shippingFee;
        final totalPrice = currentOrder.totalPrice;
        final restaurantInfo = currentOrder.restaurantInfo;
        final driverInfo = currentOrder.driverInfo;
        final startLocation = currentOrder.startLocation?.address;
        final endLocation = currentOrder.endLocation?.address;
        final formattedTime = currentOrder.formattedCreatedAt;



        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Code
                Text(
                  'Order Code: $orderCode',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                ),
                const Divider(),

                // Thông tin chi tiết
                if (orderType == 'FOOD' && restaurantInfo != null)
                  _buildFoodOrderSection(restaurantInfo, driverInfo!, endLocation!, shippingFee!, totalPrice! )
                else
                  _buildRideOrderSection(driverInfo!, startLocation!, endLocation!, totalPrice!),

                const SizedBox(height: 16.0),


                // Order Time
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Order Time: $formattedTime',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),

    );
  }

  // Widget cho FOOD order
  Widget _buildFoodOrderSection(RestaurantInfo restaurantInfo, DriverInfo driverInfo, String endLocation, double shippingFee, double totalPrice) {
    final List<OrderItem> items = orderController.currentOrder.value?.orderItems ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Restaurant Information:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        _buildInfoCard(
          imageUrl: restaurantInfo.img!,
          name: restaurantInfo.name!,
          address: restaurantInfo.restaurantLocation!,
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Driver Information:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        _buildInfoCard(
          imageUrl: driverInfo.img!,
          name: driverInfo.name!,
          address: driverInfo.phoneNumber!,
        ),
        const Divider(),
        const Text(
          'Order Items',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12.0),
        ...items.map<Widget>((item) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(item!.foodName!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
            ),
              overflow: TextOverflow.ellipsis,),
            trailing: Text("x${item.quantity}"),
          );
        }).toList(),
        const Divider(),
        // Shipping Fee
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shipping Fee',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              Text(
                '\$$shippingFee',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Color(0xFF39c5c8),
                ),
              ),

            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              Text(
                '\$$totalPrice',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Color(0xFF39c5c8),
                ),
              ),

            ],
          ),
        ),
        const SizedBox(height: 16.0),

      ],
    );
  }

  // Widget cho RIDE order
  Widget _buildRideOrderSection(
      DriverInfo driverInfo, String startLocation, String endLocation, double rideCost) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Driver Information:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        _buildInfoCard(
          imageUrl: driverInfo.img!,
          name: driverInfo.name!,
          address: driverInfo.phoneNumber!,
        ),
        const SizedBox(height: 16.0),
        const Text(
          'From - To:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        const SizedBox(height: 8.0),
        _buildAddressCard(startLocation, endLocation),
        const Divider(),
        // Shipping Fee
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ride Cost',
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              Text(
                '\$$rideCost',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Color(0xFF39c5c8),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String imageUrl,
    required String name,
    required String address,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(Constant.BACKEND_URL + imageUrl),
          radius: 30.0,
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                address,
                style: const TextStyle(color: Colors.grey, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(String start, String end) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start: $start',
          style: const TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
        const SizedBox(height: 4.0),
        Text(
          'End: $end',
          style: const TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
      ],
    );
  }


}