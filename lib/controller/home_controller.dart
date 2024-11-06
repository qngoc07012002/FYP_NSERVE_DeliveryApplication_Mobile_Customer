// home_controller.dart
import 'dart:convert';
import 'package:deliveryapplication_mobile_customer/entity/Restaurant.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../entity/Category.dart';
import '../screens/locationpicker_screen.dart';
import '../services/reserve_geo.dart';
import '../ultilities/Constant.dart';

class HomeController extends GetxController {
  var token = ''.obs;
  var selectedLocation = 'Loading...'.obs;
  var selectedIndex = 0.obs;
  var restaurants = <Restaurant>[].obs;
  var filteredRestaurants = <Restaurant>[].obs;
  var categories = <Category>[].obs;
  final LocationService locationService = LocationService();

  @override
  void onInit() {
    super.onInit();
    _loadToken();
    updateLocation();
    fetchRestaurants();
    fetchCategories();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('jwt_token') ?? '';
    print(token.value);
  }

  Future<void> updateLocation() async {
    try {
      String location = await locationService.getAddressFromCurrentLocation();
      selectedLocation.value = location;
    } catch (e) {
      print(e.toString());
      selectedLocation.value = 'Cannot get address';
    }
  }

  Future<void> fetchRestaurants() async {
    try {
      updateLocation();
      final response = await http.get(Uri.parse(Constant.RESTAURANT_URL));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        restaurants.value = jsonList.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(Constant.CATEGORY_URL));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> categoryList = data['result'];
        categories.value = categoryList.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void filterRestaurantsByCategory(String categoryId) {
    filteredRestaurants.value = restaurants.where((restaurant) =>
    restaurant.category?.id == categoryId
    ).toList();
  }

  void searchRestaurants(String query) {
    if (query.isEmpty) {
      filteredRestaurants.value = restaurants;
    } else {
      filteredRestaurants.value = restaurants.where((restaurant) {
        return restaurant.restaurantName!.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.description!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void pickLocation(Function(String, double, double) onLocationPicked) async {
    final result = await Get.to(
          () => LocationPickerScreen(onLocationPicked: onLocationPicked),
    );
    if (result != null) {
      selectedLocation.value = result;
    }
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
    print('Selected index: $selectedIndex');
  }
}
