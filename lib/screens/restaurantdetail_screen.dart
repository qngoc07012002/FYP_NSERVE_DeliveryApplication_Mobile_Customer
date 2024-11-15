import 'package:deliveryapplication_mobile_customer/screens/placeorder_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import Get package for state management
import '../controller/food_controller.dart';
import '../controller/order_controller.dart';
import '../entity/Restaurant.dart';
import '../entity/Food.dart';
import '../ultilities/Constant.dart';


class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  num _totalAmount = 0;
  final FoodController _foodController = Get.put(FoodController());
  final OrderController _orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    // Fetch food data when the page loads
    _foodController.fetchFoods(widget.restaurant.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant Detail',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: Obx(() {
        if (_foodController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Update the dishes list with the data from the controller
        final dishes = _foodController.foods;

        return Column(
          children: [
            // Restaurant Information
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      Constant.BACKEND_URL + widget.restaurant.imgUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.restaurantName!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          widget.restaurant.description!,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4.0),
                            Text(
                              widget.restaurant.rating!.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Divider
            Container(
              height: 2.0,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16.0),

            // Dishes List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(12.0)),
                          child: Image.network(
                            Constant.IMG_URL +  dishes[index].imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              dishes[index].name!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('\$${dishes[index].price}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => _decreaseQuantity(index),
                                ),
                                Text('${dishes[index].quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => _increaseQuantity(index),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _totalAmount > 0
          ? InkWell(
        onTap: () {
          _orderController.selectedFoods.assignAll(
              _foodController.foods.where((food) => food.quantity > 0));
          _orderController.restaurant.value = widget.restaurant;
          _orderController.totalAmount.value = _totalAmount.toDouble();
          Get.to(OrderSummaryPage());
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Color(0xFF39c5c8),
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                '\$${_totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      )
          : null,

    );
  }

  void _increaseQuantity(int index) {
    setState(() {
      _foodController.foods[index].quantity++;
      _totalAmount += _foodController.foods[index].price;
    });
  }

  void _decreaseQuantity(int index) {
    if (_foodController.foods[index].quantity > 0) {
      setState(() {
        _foodController.foods[index].quantity--;
        _totalAmount -= _foodController.foods[index].price;
      });
    }
  }

  List<Map<String, dynamic>> _getSelectedItems() {
    return _foodController.foods
        .where((food) => food.quantity > 0)
        .map((food) => {
      'name': food.name,
      'quantity': food.quantity,
      'total': food.price * food.quantity,
    })
        .toList();
  }

}
