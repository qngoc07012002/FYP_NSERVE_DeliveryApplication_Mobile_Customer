import 'package:deliveryapplication_mobile_customer/screens/changepassword_screen.dart';
import 'package:flutter/material.dart';

import 'editprofile_screen.dart';
import 'order_screen.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            // Profile picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(
                        'https://www.w3schools.com/w3images/avatar2.png'), // Example image URL
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
