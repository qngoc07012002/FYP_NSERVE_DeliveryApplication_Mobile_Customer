import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../entity/User.dart';
import '../ultilities/Constant.dart';
class UserController extends GetxController {
  var user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUserInfo();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

// Fetch thông tin user từ API
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
      // Nếu không thành công, in ra mã lỗi
      print('Failed to fetch user info. Status code: ${response.statusCode}');
    }
  }


}