import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entity/Restaurant.dart';
import '../entity/Food.dart';
import '../screens/locationpicker_screen.dart';
import 'package:http/http.dart' as http;

import '../ultilities/Constant.dart';

class OrderController extends GetxController {
  var restaurant = Rxn<Restaurant>();
  var selectedFoods = <Food>[].obs;
  var totalAmount = 0.0.obs;
  var shippingFee = 0.0.obs;
  var selectedPaymentMethod = 'Credit'.obs;
  var distance = 0.0.obs;

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



}
