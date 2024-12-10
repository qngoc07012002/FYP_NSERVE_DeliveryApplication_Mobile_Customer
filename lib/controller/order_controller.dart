import 'dart:async';
import 'dart:convert';

import 'package:deliveryapplication_mobile_customer/controller/orderprocessing_controller.dart';
import 'package:deliveryapplication_mobile_customer/controller/user_controller.dart';
import 'package:deliveryapplication_mobile_customer/entity/orderRequest_model.dart';
import 'package:deliveryapplication_mobile_customer/entity/paymentResponse_model.dart';
import 'package:deliveryapplication_mobile_customer/screens/homepage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../entity/location_model.dart';
import '../entity/order_model.dart';
import '../entity/orderItem_model.dart';
import '../entity/restaurant_model.dart';
import '../entity/food_model.dart';
import '../screens/locationpicker_screen.dart';
import 'package:http/http.dart' as http;

import '../services/stripe_service.dart';
import '../services/websocket_service.dart';
import '../ultilities/Constant.dart';

class OrderController extends GetxController {
  var isLoading = true.obs;
  var restaurant = Rxn<Restaurant>();
  var selectedFoods = <Food>[].obs;
  var totalAmount = 0.0.obs;
  var shippingFee = 0.0.obs;
  var selectedPaymentMethod = 'Cash'.obs;
  var distance = 0.0.obs;
  final WebSocketService _webSocketService = Get.find();
  bool isDialogVisible = false;
  var orders = <Order>[].obs;
  UserController userController = Get.find();
  OrderProcessingController orderProcessingController = Get.find();
  var currentOrder = Rx<Order?>(null);
  Timer? driverLocationTimer;

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

          orders.value = ordersData
              .map((orderJson) => Order.fromJson(orderJson))
              .where((order) => order.orderStatus == "DELIVERED")
              .toList()
            ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

        //  orders.value = ordersData.map((orderJson) => Order.fromJson(orderJson)).toList();
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

  Future<void> fetchOrderById(String orderId) async {
    String jwtToken = await getToken();

    final response = await http.get(
      Uri.parse('${Constant.ORDER_CUSTOMER_URL}/$orderId'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = jsonDecode(responseBody);
    //  final Map<String, dynamic> data = json.decode(response.body);
      final Order order = Order.fromJson(data['result']);
      print(order);
      currentOrder.value = order;
      isLoading.value = false;
      fetchOrders();
    } else {
      isLoading.value = false;
      print('Failed to load order by ID: ${response.statusCode}');
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

  Future<bool> sendOrderFoodRequest() async {
    try {
      if (await checkRestaurantAvailable() == false)
        {
          return false;
        }


      final prefs = await SharedPreferences.getInstance();
      final customerLat = prefs.getDouble('latitude');
      final customerLng = prefs.getDouble('longitude');
      final customerAddress = prefs.getString('address') ?? 'Unknown Address';
      String paymentIntentId = "";

      if (restaurant.value == null || selectedFoods.isEmpty) {
        print("Restaurant or food items are missing");
        return false;
      }

      if (selectedPaymentMethod.value == "Credit"){
        paymentIntentId = await StripeService.instance.makePayment(totalAmount.value + shippingFee.value);
        if (paymentIntentId == ""){
          return false;
        }
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
        paymentIntentId: paymentIntentId,
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
      if (response.statusCode == 200) {
        orderProcessingController.hasOrder.value = true;
        orderProcessingController.latStart.value = restaurant.value!.location!.latitude!;
        orderProcessingController.lngStart.value = restaurant.value!.location!.longitude!;
         orderProcessingController.latEnd.value = customerLat!;
         orderProcessingController.lngEnd.value = customerLng!;
        print("Order sent successfully.");
        return true;
      } else {

      }
      return false;
    } catch (e) {
      print("Error in sending order request: $e");
    return false;
    }
  }

  Future<bool> checkRestaurantAvailable() async {
    try {

      String? jwtToken = await getToken();

      final url = Uri.parse(Constant.RESTAURANT_URL+ "/checkRestaurantStatus/"+ restaurant.value!.id!);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.get(url, headers: headers);
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (response.statusCode == 200) {
        print("Restaurant is available");
        return true;
      } else {
        if (responseData['result'] == "OFFLINE") {
          Get.defaultDialog(
            title: "Restaurant Offline",
            middleText: responseData['message'],
            textConfirm: "OK",
            confirmTextColor: Colors.white,
            onConfirm: () {
              Get.back();
            },
            barrierDismissible: false,
          );
        }
      }
      return false;
    } catch (e) {
      print("Error in sending order request: $e");
      return false;
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
            await fetchOrderById(jsonData['body']['orderId']);
            orderProcessingController
                .updateStoreInfo(
                currentOrder.value!.restaurantInfo!.name!,
                currentOrder.value!.restaurantInfo!.restaurantLocation!,
                currentOrder.value!.restaurantInfo!.img!);
            // for (var order in orders){
            //   if (order.id == jsonData['body']['orderId']){
            //     orderProcessingController.updateStoreInfo(order.restaurantInfo!.name!, order.restaurantInfo!.restaurantLocation!, order.restaurantInfo!.img!);
            //     break;
            //   }
            // }
           // orderProcessingController.updateStoreInfo("Ngoc Restaurant", "123 Nguyen Hoang", "https://cdn0.iconfinder.com/data/icons/online-shopping-184/128/Delivery_man-512.png");
          }

          if (jsonData['action'] == "DRIVER_ACCEPT_ORDER") {
            await fetchOrderById(jsonData['body']['orderId']);
            orderProcessingController
                .updateDriverInfo(
                currentOrder.value!.driverInfo!.name!,
                currentOrder.value!.driverInfo!.phoneNumber!,
                currentOrder.value!.driverInfo!.img!);
            // for (var order in orders){
            //   if (order.id == jsonData['body']['orderId']){
            //     orderProcessingController.updateDriverInfo(order.driverInfo!.name!, order.driverInfo!.phoneNumber!, order.driverInfo!.img!);
            //     break;
            //   }

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
           // orderProcessingController.isDelivering.value = true;
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
            driverLocationTimer?.cancel();
            driverLocationTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
              await fetchDriverLocation();
            });
          }

          if (jsonData['action'] == "DRIVER_DELIVERED_ORDER") {
            driverLocationTimer?.cancel();
            orderProcessingController.updateOrderStatus("Delivered");
            Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Notification",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        Text(
                          "The driver has arrived.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 24.0),

                        ElevatedButton(
                          onPressed: () {
                            orderProcessingController.resetData();
                            fetchOrders();
                            Get.back();
                            Get.offAll(HomePage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF39c5c8), // Màu nút
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          ),
                          child: Text(
                            "OK",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));

          }

          if (jsonData['action'] == "NO_DRIVER_FOUND"){
            Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Notification",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        Text(
                          "No driver found for this order.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 24.0),

                        ElevatedButton(
                          onPressed: () {
                            orderProcessingController.resetData();
                            fetchOrders();
                            Get.back();
                            Get.offAll(HomePage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF39c5c8), // Màu nút
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          ),
                          child: Text(
                            "OK",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));

          }

          if (jsonData['action'] == "RESTAURANT_DECLINE_ORDER"){
            Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Notification",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        Text(
                          "Restaurant decline this order.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 24.0),

                        ElevatedButton(
                          onPressed: () {
                            orderProcessingController.resetData();
                            fetchOrders();
                            Get.back();
                            Get.offAll(HomePage());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF39c5c8), // Màu nút
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                          ),
                          child: Text(
                            "OK",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }

        } catch (e) {
          print("Error parsing JSON: $e");
        }
      }
    });
  }

  Future<void> fetchDriverLocation() async {
    try {
      String? jwtToken = await getToken();
      final response = await http.get(
        Uri.parse('${Constant.DRIVER_URL}/getDriverLocation/1'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 1000) {
          double latitude = data['result']['latitude'];
          double longitude = data['result']['longitude'];
          print('Driver Location - Latitude: $latitude, Longitude: $longitude');
          orderProcessingController.latStart.value = latitude;
          orderProcessingController.lngStart.value = longitude;
        } else {
          print('Failed to retrieve driver location: ${data['message']}');
        }
      } else {
        print('Error fetching driver location: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching driver location: $e");
    }
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
