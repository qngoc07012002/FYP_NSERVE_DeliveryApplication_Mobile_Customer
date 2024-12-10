import 'dart:convert';

import 'package:deliveryapplication_mobile_customer/screens/homepage_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../entity/user_model.dart';
import '../screens/login_screen.dart';
import '../ultilities/Constant.dart';
import 'home_controller.dart';
import 'order_controller.dart';
import 'orderprocessing_controller.dart';
class UserController extends GetxController {
  var user = Rx<User?>(null);
  var phoneNumber = "".obs;

  @override
  void onInit() {
    super.onInit();
   // fetchUserInfo();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<void> fetchUserInfo() async {
    String? jwtToken = await getToken();

    if (jwtToken.isEmpty) {
      print("JWT token not found!");
      return;
    }

    final response = await http.get(
      Uri.parse(Constant.USER_INFO_URL),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      user.value = User.fromJson(data['result']);

      print('User Info:');
      print('ID: ${user.value?.id}');
      print('Phone: ${user.value?.phoneNumber}');
      print('Email: ${user.value?.email}');
      print('Full Name: ${user.value?.fullName}');
    } else {
      print('Failed to fetch user info. Status code: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    final String token = await getToken();



    const url = Constant.LOGOUT_URL;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {


      Get.snackbar('Success', 'You have logged out successfully');

    } else {
      Get.snackbar('Error', 'Failed to logout: ${response.reasonPhrase}');
    }
    Get.offAll(const LoginPage());
  }

  Future<void> checkTokenValidity() async {
    final String token = await getToken();
    const url = Constant.INTROSPECT_URL;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final bool isValid = responseBody['result']['valid'];

      if (isValid) {
        await fetchUserInfo();
        Get.put(HomeController());
        //Get.put(NotificationController());
        Get.put(OrderProcessingController());
        Get.put(OrderController());
        Get.offAll(HomePage());
      }
    }
  }


}