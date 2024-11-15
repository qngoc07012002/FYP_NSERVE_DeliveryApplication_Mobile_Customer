import 'package:deliveryapplication_mobile_customer/screens/chat_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/homepage_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/login_screen.dart';
import 'package:deliveryapplication_mobile_customer/services/websocket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'controller/notification_controller.dart';

void main() {
  Get.put(WebSocketService()); // Initial Websocket
  Get.put(NotificationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ABC",
      home: HomePage(),
    );
  }
}


