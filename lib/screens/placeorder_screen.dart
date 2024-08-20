import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  _OrderSummaryPageState createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  String _selectedAddress = 'Default Address';
  String _selectedPaymentMethod = 'Cash';

  void _selectAddress() {
    // Logic for selecting address
    // For demo purposes, we will show a bottom sheet
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              title: Text('Address 1'),
              onTap: () => Navigator.pop(context, 'Address 1'),
            ),
            ListTile(
              title: Text('Address 2'),
              onTap: () => Navigator.pop(context, 'Address 2'),
            ),
            ListTile(
              title: Text('Address 3'),
              onTap: () => Navigator.pop(context, 'Address 3'),
            ),
          ],
        );
      },
    ).then((selected) {
      if (selected != null) {
        setState(() {
          _selectedAddress = selected;
        });
      }
    });
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
              title: Text('Visa'),
              onTap: () => Navigator.pop(context, 'Visa'),
            ),
            ListTile(
              leading: Icon(Icons.paypal, color: Colors.black),
              title: Text('Paypal'),
              onTap: () => Navigator.pop(context, 'Paypal'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF39c5c8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Section
            GestureDetector(
              onTap: _selectAddress,
              child: Container(
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
                      child: Text(_selectedAddress, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const Icon(Icons.edit, color: Color(0xFF39c5c8)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Order Summary
            Container(
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
                  Text('Item 1: \$10.00'),
                  Text('Item 2: \$15.00'),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Shipping Fee', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('\$5.00'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('\$30.00', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

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
                          : _selectedPaymentMethod == 'Visa'
                          ? Icons.credit_card
                          : Icons.paypal,
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
            const Spacer(),

            // Place Order Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic to place the order
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39c5c8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 100),
                ),
                child: Text('Place Order', style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16.0), // Added space at the bottom
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: OrderSummaryPage(),
  ));
}
