import 'package:deliveryapplication_mobile_customer/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../ultilities/Constant.dart';
import 'editprofile_screen.dart';
import 'order_screen.dart';

class ProfilePage extends StatelessWidget {

  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            // Profile picture
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(
                            Constant.IMG_URL + userController.user.value!.imgUrl),
                      ),

                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '${userController.user.value!.fullName}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
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
                userController.logout();
              },
            ),
            Divider(color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
