import 'package:deliveryapplication_mobile_customer/screens/homepage_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/landing_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ABC",
      home: const HomePage(),
    );
  }
}


