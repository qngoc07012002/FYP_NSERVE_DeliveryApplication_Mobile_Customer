import 'dart:convert';

import 'package:deliveryapplication_mobile_customer/controller/orderprocessing_controller.dart';
import 'package:deliveryapplication_mobile_customer/controller/user_controller.dart';
import 'package:deliveryapplication_mobile_customer/entity/OrderRequest.dart';
import 'package:deliveryapplication_mobile_customer/screens/homepage_screen.dart';
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
  var isLoading = true.obs;
  var restaurant = Rxn<Restaurant>();
  var selectedFoods = <Food>[].obs;
  var totalAmount = 0.0.obs;
  var shippingFee = 0.0.obs;
  var selectedPaymentMethod = 'Credit'.obs;
  var distance = 0.0.obs;
  final WebSocketService _webSocketService = Get.find();
  bool isDialogVisible = false;
  var orders = <Order>[].obs;
  UserController userController = Get.find();
  OrderProcessingController orderProcessingController = Get.find();
  var currentOrder = Rx<Order?>(null);


  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
    await userController.fetchUserInfo();
    fetchOrders();
    subscribeToOrderUpdates();

  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      String? jwtToken = await getToken();
      var response = await http.get(
        Uri.parse(Constant.ORDER_CUSTOMER_URL),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );
      if (response.statusCode == 200) {
        var responseBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(responseBody);
        if (data['code'] == 1000) {
          print(data['result']);
          final List<dynamic> ordersData = data['result'];

          orders.value = ordersData.map((orderJson) => Order.fromJson(orderJson)).toList();
         // orders.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
          print ("ORDER LENGTH: ${orders.length}");
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
        print('Failed to fetch orders');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
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

  Future<void> sendOrderFoodRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerLat = prefs.getDouble('latitude');
      final customerLng = prefs.getDouble('longitude');
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
      OrderRequest orderRequest = OrderRequest(
        restaurantId: restaurant.value!.id,
        customerLocation: customerLocation,
        orderItems: orderItems,
        shippingFee: shippingFee.value,
        distance: distance.value,
        totalPrice: totalAmount.value,
        orderType: "FOOD",
        paymentMethod: selectedPaymentMethod.value,
      );

      // _webSocketService.sendMessage('/app/order/customer/createOrder', orderRequest.toJson());
      final jwtToken = prefs.getString('jwt_token');

      final url = Uri.parse(Constant.CREATE_ORDER_URL);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };
      final body = jsonEncode(orderRequest.toJson());

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200){
        print("Order sent successfully.");
      } else {
        print("Order sent failed.");
      }

    } catch (e) {
      print("Error in sending order request: $e");
    }
  }

  void subscribeToOrderUpdates() {

    UserController userController = Get.find();

    _webSocketService.subscribe(
        '/queue/customer/order/${userController.user.value!.id}',
            (frame) async  {
      if (frame.body != null) {
        // String message = frame.body!;
        // showNotificationDialog(message);

        try {
          // Parse JSON body
          Map<String, dynamic> jsonData = jsonDecode(frame.body!);
          print(jsonData);
          if (jsonData['action'] == "RESTAURANT_ACCEPT_ORDER") {
            Get.snackbar(
              "Order Notification",
              "The store has accepted the order.",
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xFF39c5c8),
              colorText: Colors.white,
              borderRadius: 20,
              margin: const EdgeInsets.all(16),
              icon: const Icon(
                Icons.notifications_active,
                color: Colors.white,
              ),
              duration: const Duration(seconds: 7),
              isDismissible: true,
              forwardAnimationCurve: Curves.easeOutBack,
              reverseAnimationCurve: Curves.easeInBack,

            );
            await fetchOrders();
            for (var order in orders){
              if (order.id == jsonData['body']['orderId']){
                orderProcessingController.updateStoreInfo(order.restaurantInfo!.name!, order.restaurantInfo!.restaurantLocation!, order.restaurantInfo!.img!);
                break;
              }
            }
           // orderProcessingController.updateStoreInfo("Ngoc Restaurant", "123 Nguyen Hoang", "https://cdn0.iconfinder.com/data/icons/online-shopping-184/128/Delivery_man-512.png");
          }

          if (jsonData['action'] == "DRIVER_ACCEPT_ORDER") {
            await fetchOrders();
            for (var order in orders){
              if (order.id == jsonData['body']['orderId']){
                orderProcessingController.updateDriverInfo(order.driverInfo!.name!, order.driverInfo!.phoneNumber!, order.driverInfo!.img!);
                break;
              }
            }

            orderProcessingController.updateOrderStatus("Preparing");
            Get.snackbar(
              "Order Notification",
              "Order is being prepared",
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xFF39c5c8),
              colorText: Colors.white,
              borderRadius: 20,
              margin: const EdgeInsets.all(16),
              icon: const Icon(
                Icons.notifications_active,
                color: Colors.white,
              ), // Biểu tượng
              duration: const Duration(seconds: 7),
              isDismissible: true,
              forwardAnimationCurve: Curves.easeOutBack,
              reverseAnimationCurve: Curves.easeInBack,

            );

          }

          if (jsonData['action'] == "DRIVER_DELIVERING_ORDER") {
            orderProcessingController.updateOrderStatus("Delivering");
           // Get.snackbar("Oder Notification", "Order is being delivered");
            Get.snackbar(
              "Order Notification",
              "Order is being delivered",
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xFF39c5c8),
              colorText: Colors.white,
              borderRadius: 20,
              margin: const EdgeInsets.all(16),
              icon: const Icon(
                Icons.notifications_active,
                color: Colors.white,
              ), // Biểu tượng
              duration: const Duration(seconds: 7),
              isDismissible: true,
              forwardAnimationCurve: Curves.easeOutBack,
              reverseAnimationCurve: Curves.easeInBack,

            );

          }

          if (jsonData['action'] == "DRIVER_DELIVERED_ORDER") {
            orderProcessingController.updateOrderStatus("Delivered");
            //Get.snackbar("Oder Notification", "Order has been delivered");
            Get.snackbar(
              "Order Notification",
              "Order has been delivered",
              snackPosition: SnackPosition.TOP,
              backgroundColor: const Color(0xFF39c5c8),
              colorText: Colors.white,
              borderRadius: 20,
              margin: const EdgeInsets.all(16),
              icon: const Icon(
                Icons.notifications_active,
                color: Colors.white,
              ), // Biểu tượng
              duration: const Duration(seconds: 7),
              isDismissible: true,
              forwardAnimationCurve: Curves.easeOutBack,
              reverseAnimationCurve: Curves.easeInBack,

            );
          }

          if (jsonData['action'] == "NO_DRIVER_FOUND"){
            Get.defaultDialog(
              title: "Notification",
              middleText: "No driver found for this order. ",
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                fetchOrders();
                Get.back();
                Get.offAll(HomePage());
              },
              barrierDismissible: false,
            );
          }

          if (jsonData['action'] == "RESTAURANT_DECLINE_ORDER"){
            Get.defaultDialog(
              title: "Notification",
              middleText: "Restaurant decline this order.",
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                fetchOrders();
                Get.back();
                Get.offAll(HomePage());
              },
              barrierDismissible: false,
            );
          }

          // // Kiểm tra các trường `null` trước khi truy cập
          // String orderId = jsonData['id'] ?? 'N/A';
          // Map<String, dynamic>? user = jsonData['user'];
          // String userId = user != null ? user['id'] ?? 'N/A' : 'N/A';
          //
          // Map<String, dynamic>? restaurant = jsonData['restaurant'];
          // String restaurantName = restaurant != null ? restaurant['restaurantName'] ?? 'Unknown Restaurant' : 'N/A';
          //
          // print("Order ID: $orderId");
          // print("User ID: $userId");
          // print("Restaurant Name: $restaurantName");

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
