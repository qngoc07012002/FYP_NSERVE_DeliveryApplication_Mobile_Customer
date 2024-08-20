import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Card list section
          _buildCardItem(
            'Visa •••• 4242',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/1024px-Visa_Inc._logo.svg.png',
            onTap: () {
              // Handle card selection
            },
          ),
          _buildCardItem(
            'MasterCard •••• 1234',
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/MasterCard_Logo.svg/1280px-MasterCard_Logo.svg.png',
            onTap: () {
              // Handle card selection
            },
          ),
          _buildCardItem(
            'PayPal',
            'https://upload.wikimedia.org/wikipedia/commons/a/a4/Paypal_2014_logo.png',
            onTap: () {
              // Handle PayPal selection
            },
          ),
          const SizedBox(height: 20.0),
          // Add payment method button
          ElevatedButton.icon(
            onPressed: () {
              // Handle add payment method action
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Payment Method', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF39c5c8),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(String cardName, String assetPath, {required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        onTap: onTap,
        leading: Image.network(assetPath, width: 50.0),
        title: Text(cardName),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
