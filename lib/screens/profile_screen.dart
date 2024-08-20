import 'package:deliveryapplication_mobile_customer/screens/changepassword_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/payment_screen.dart';
import 'package:flutter/material.dart';

import 'editprofile_screen.dart';
import 'order_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile',  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            // Profile picture
            const Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(
                        'https://scontent.fsgn2-3.fna.fbcdn.net/v/t39.30808-6/448249343_2254063974927591_3013120637072065076_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=u9k1rh_qdN8Q7kNvgHeWbBb&_nc_ht=scontent.fsgn2-3.fna&oh=00_AYB0lp00TWjdTXz3ijJJaz2rqg7zo3fOEQcZDN6BtJ1Q8A&oe=66CA595B'), // Example image URL
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Profile options
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFF39c5c8)),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(),
                  ),
                );
              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              leading: const Icon(Icons.lock, color: Color(0xFF39c5c8)),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(),
                  ),
                );
              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              leading: const Icon(Icons.history, color: Color(0xFF39c5c8)),
              title: const Text('Order History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPage(),
                  ),
                );
              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              leading: const Icon(Icons.payment, color: Color(0xFF39c5c8)),
              title: const Text('Payment'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(),
                  ),
                );
              },
            ),
            Divider(color: Colors.grey[300]),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                // Handle Logout action
              },
            ),
            Divider(color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
