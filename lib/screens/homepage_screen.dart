// home_page.dart
import 'package:deliveryapplication_mobile_customer/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../controller/orderprocessing_controller.dart';
import '../entity/restaurant_model.dart';
import '../ultilities/Constant.dart';
import 'locationpicker_screen.dart';
import 'orderprocessing_screen.dart';
import 'profile_screen.dart';
import 'restaurant_filter_screen.dart';
import 'restaurantdetail_screen.dart';
import 'bookbike_screen.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final OrderProcessingController orderProcessingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Obx(() => RefreshIndicator(
            onRefresh: controller.fetchRestaurants,
            child: IndexedStack(
              index: controller.selectedIndex.value,
              children: [
                _buildHomePage(),
                OrderPage(),

                ProfilePage(),
              ],
            ),
          )),
          bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Food'),
              BottomNavigationBarItem(icon: Icon(Icons.reorder), label: 'Order'),

              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            ],
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: const Color(0xFF39c5c8),
            unselectedItemColor: Colors.grey,
            onTap: controller.onItemTapped,
          )),
        ),
        Obx(() {
          if (orderProcessingController.hasOrder.value) {
            return Positioned(
              bottom: 70,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => OrderProcessingPage());
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delivery_dining, color: Color(0xFF39c5c8), size: 32),
                      const SizedBox(width: 16.0),

                      const Icon(Icons.arrow_forward, color: Color(0xFF39c5c8)),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildHomePage() {
    return Obx(() => RefreshIndicator(
      onRefresh: controller.fetchRestaurants,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24.0),
            _buildCategorySection(),
            const SizedBox(height: 24.0),
            _buildRestaurantList(),
          ],
        ),
      ),
    ));
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF39c5c8),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20.0)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () => controller.pickLocation((address, lat, lng) {
              controller.selectedLocation.value = address.split(',').first;
            }),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white),
                const SizedBox(width: 4.0),
                Obx(() => Text(
                  '${controller.selectedLocation.value.split(',').first} ',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                )),
                const Icon(Icons.edit, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for food or restaurants',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF39c5c8)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (query) {
              controller.searchRestaurants(query);
              Get.to(() => FilterPage());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryItem('Rice', Icons.rice_bowl, "1"),
              _buildCategoryItem('Drink', Icons.local_drink, "2"),
              _buildCategoryItem('Fast Food', Icons.fastfood, "3"),
              _buildCategoryItem('Desserts', Icons.cake, "4"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, String categoryId) {
    return GestureDetector(
      onTap: () {
        controller.filterRestaurantsByCategory(categoryId);
        Get.to(() => FilterPage());
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF39c5c8).withOpacity(0.8),
            radius: 32,
            child: Icon(icon, size: 32, color: Colors.white),
          ),
          const SizedBox(height: 8.0),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildRestaurantList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          for (var restaurant in controller.restaurants)
            _buildStoreItem(
              restaurant: restaurant,
            ),
        ],
      ),
    );
  }

  Widget _buildStoreItem({
    required Restaurant restaurant,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RestaurantDetailPage(restaurant: restaurant,));
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.network(
                Constant.IMG_URL + restaurant.imgUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset('assets/images/food_image.png', width: 80, height: 80, fit: BoxFit.cover);
                },
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurant.restaurantName!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4.0),
                    Text(restaurant.description!, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        Text('${restaurant.rating}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
