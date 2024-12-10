import 'package:deliveryapplication_mobile_customer/controller/home_controller.dart';
import 'package:deliveryapplication_mobile_customer/controller/order_controller.dart';
import 'package:deliveryapplication_mobile_customer/controller/orderprocessing_controller.dart';
import 'package:deliveryapplication_mobile_customer/controller/user_controller.dart';
import 'package:deliveryapplication_mobile_customer/screens/chat_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/homepage_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/login_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/orderprocessing_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/register_screen.dart';
import 'package:deliveryapplication_mobile_customer/services/websocket_service.dart';
import 'package:deliveryapplication_mobile_customer/ultilities/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'controller/notification_controller.dart';

void main() async{


  Get.put(WebSocketService());
  Get.put(UserController());


  await _setupStripe();
  runApp(GetMaterialApp(
    home: LoginPage(),
  ));
}

Future<void> _setupStripe() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = Constant.stripePublishableKey;
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


