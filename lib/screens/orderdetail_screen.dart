import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng thời gian

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Fake data for delivery person
    final deliveryPerson = {
      'name': 'Béo',
      'avatarUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnihI8ux-tT_Z1JF8toQIn05jA8PO--cdCJELNtoYDXoA2C1FbkjQLE34NTjbsvyo0nXU&usqp=CAU'
    };

    // If 'items' is not a List or null, use fake data
    final List<Map<String, dynamic>> items = (order['items'] is List)
        ? List<Map<String, dynamic>>.from(order['items'])
        : [
      {'name': 'Margherita Pizza', 'quantity': 2},
      {'name': 'Pepperoni Pizza', 'quantity': 1},
      {'name': 'California Roll', 'quantity': 3},
      {'name': 'Spicy Tuna Roll', 'quantity': 2},
    ];

    // Format the order time
    final orderTime = (order['orderTime'] as DateTime?) ?? DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd – HH:mm').format(orderTime);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery person details
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.blueGrey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF39c5c8).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(deliveryPerson['avatarUrl']!),
                    radius: 30.0,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      deliveryPerson['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Restaurant details
            Text(
              order['restaurantName'] ?? 'Unknown Restaurant',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 8.0),

            // Order details (styled like a receipt)
            Container(
              padding: const EdgeInsets.all(16.0),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Details:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  for (var item in items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['name'] ?? 'Unknown Item',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'x${item['quantity'] ?? 0}',
                            style: const TextStyle(color: Colors.grey, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 24.0, thickness: 1.0),
                  Text(
                    '$formattedTime',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Total: \$${order['amount']?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
