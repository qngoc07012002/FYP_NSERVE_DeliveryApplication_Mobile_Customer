import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../entity/Location.dart';
import '../entity/Order.dart';
import '../entity/OrderItem.dart';
import '../entity/Restaurant.dart';
import '../entity/Food.dart';
import '../screens/locationpicker_screen.dart';
import 'package:http/http.dart' as http;

import '../services/websocket_service.dart';
import '../ultilities/Constant.dart';

class OrderController extends GetxController {
  var restaurant = Rxn<Restaurant>();
  var selectedFoods = <Food>[].obs;
  var totalAmount = 0.0.obs;
  var shippingFee = 0.0.obs;
  var selectedPaymentMethod = 'Credit'.obs;
  var distance = 0.0.obs;
  final WebSocketService _webSocketService = Get.find();
  bool isDialogVisible = false;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  Future<void> calculateShippingFee() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerLat = prefs.getDouble('latitude');
      final customerLng = prefs.getDouble('longitude');
      final jwtToken = prefs.getString('jwt_token');
      final restaurantId = restaurant.value?.id;

      if (customerLat == null || customerLng == null || jwtToken == null || restaurantId == null) {
        print("Not enough information to calculate shipping costs.");
        return;
      }
      
      final url = Uri.parse(Constant.SHIPPING_FEE_URL);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };
      final body = jsonEncode({
        "restaurantId": restaurantId.toString(),
        "customerLat": customerLat,
        "customerLng": customerLng,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['code'] == 1000) {
          final result = responseData['result'];
          distance.value = result['distance'];
          shippingFee.value = result['shippingFee'];
          print("Distance: ${distance.value}, Shipping Fee: ${shippingFee.value}");
        } else {
          print("Error from server: ${responseData['code']}");
        }
      } else {
        print("Error calling API: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in calculating shipping costs: $e");
    }
  }

  void setRestaurant(Restaurant restaurant) {
    this.restaurant.value = restaurant;
  }

  void clearOrder() {
    selectedFoods.clear();
    totalAmount.value = 0.0;
    shippingFee.value = 0.0;
    distance.value = 0.0;
    restaurant.value = null;
  }

  Future<void> sendOrderRequest() async {
    try {
      subscribeToOrderUpdates();
      final prefs = await SharedPreferences.getInstance();
      final customerLat = prefs.getDouble('latitude')?.toString();
      final customerLng = prefs.getDouble('longitude')?.toString();
      final customerAddress = prefs.getString('address') ?? 'Unknown Address';

      if (restaurant.value == null || selectedFoods.isEmpty) {
        print("Restaurant or food items are missing");
        return;
      }

      List<OrderItem> orderItems = selectedFoods.map((food) {
        return OrderItem(
          foodName: food.name,
          quantity: food.quantity,
          totalPrice: food.price * food.quantity,
        );
      }).toList();

      Location customerLocation = Location(
        latitude: customerLat,
        longitude: customerLng,
        address: customerAddress,
      );

      // Tạo Order request
      Order orderRequest = Order(
        restaurantId: restaurant.value!.id,
        customerLocation: customerLocation,
        orderItems: orderItems,
        shippingFee: shippingFee.value,
        distance: distance.value,
        totalPrice: totalAmount.value + shippingFee.value,
        orderType: "FOOD",
        paymentMethod: selectedPaymentMethod.value,
      );

      _webSocketService.sendMessage('/app/order/customer/createOrder', orderRequest.toJson());

      print("Order sent successfully via WebSocket.");
    } catch (e) {
      print("Error in sending order request: $e");
    }
  }

  void subscribeToOrderUpdates() {
    _webSocketService.subscribe('/queue/customer/order/123', (StompFrame frame) {
      if (frame.body != null) {
        // String message = frame.body!;
        // showNotificationDialog(message);

        try {
          // Parse JSON body
          Map<String, dynamic> jsonData = jsonDecode(frame.body!);

          // Kiểm tra các trường `null` trước khi truy cập
          String orderId = jsonData['id'] ?? 'N/A';
          Map<String, dynamic>? user = jsonData['user'];
          String userId = user != null ? user['id'] ?? 'N/A' : 'N/A';

          Map<String, dynamic>? restaurant = jsonData['restaurant'];
          String restaurantName = restaurant != null ? restaurant['restaurantName'] ?? 'Unknown Restaurant' : 'N/A';

          print("Order ID: $orderId");
          print("User ID: $userId");
          print("Restaurant Name: $restaurantName");

        } catch (e) {
          print("Error parsing JSON: $e");
        }
      }
    });
  }

  void showNotificationDialog(String message) {
    if (isDialogVisible) return;
    isDialogVisible = true;

    Get.defaultDialog(
      title: "Order Update",
      content: Text(message),
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        isDialogVisible = false;  // Reset flag when the dialog is closed
      },
    );
  }

}
