import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entity/food_model.dart';
import '../ultilities/Constant.dart';


class FoodController extends GetxController {
  var foods = <Food>[].obs;
  var isLoading = false.obs;

  Future<void> fetchFoods(String restaurantId) async {
    isLoading(true);
    try {
      final response = await http.get(
        Uri.parse(Constant.FOOD_URL + '/restaurant/$restaurantId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['result'];
        foods.value = (data as List).map((food) => Food.fromJson(food)).toList();
      } else {
        throw Exception('Failed to load foods');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }
}
