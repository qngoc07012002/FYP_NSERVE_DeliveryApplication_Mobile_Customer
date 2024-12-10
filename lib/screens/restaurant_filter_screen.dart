import 'package:deliveryapplication_mobile_customer/screens/restaurantdetail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/home_controller.dart';
import '../entity/category_model.dart';
import '../entity/restaurant_model.dart';
import '../ultilities/Constant.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  final HomeController controller = Get.find();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    controller.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Container(
          margin: const EdgeInsets.only(top: 11),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
              hintText: 'Search for stores...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              prefixIcon: Icon(Icons.search, color: Color(0xFF39c5c8)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              controller.searchRestaurants(value);
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Container(
            color: Colors.white, // Background color for filter section
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() {
              // Use the categories from the controller
              List<String> categories = ['All'] + controller.categories.map((category) => category.name!).toList();
              return DropdownButton<String>(
                value: _selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;

                    if (_selectedCategory == 'All') {
                      controller.filteredRestaurants.value = controller.restaurants;
                    } else {
                      final category = controller.categories.firstWhere(
                            (category) => category.name == _selectedCategory,
                        orElse: () => Category(id: '', name: ''),
                      );
                      controller.filterRestaurantsByCategory(category.id!);
                    }
                  });
                },

                isExpanded: true,
                underline: Container(), // Remove underline
                icon: Icon(Icons.filter_list, color: Color(0xFF39c5c8)),
                dropdownColor: Colors.white, // Match filter section background
                style: const TextStyle(color: Colors.black),
              );
            }),
          ),
        ),
      ),
      body: Obx(() {
        final filteredStores = controller.filteredRestaurants;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: filteredStores.length,
          itemBuilder: (context, index) {
            final store = filteredStores[index];
            return _buildStoreItem(
              id: store.id!,
              name: store.restaurantName!,
              imageUrl: store.imgUrl!,
              description: store.description!,
              rating: store.rating!,
            );
          },
        );
      }),
    );
  }

  Widget _buildStoreItem({
    required String id,
    required String name,
    required String imageUrl,
    required String description,
    required double rating,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RestaurantDetailPage(restaurant: Restaurant(
          id: id,
          restaurantName: name,
          imgUrl: imageUrl,
          description: description,
          rating: rating,
        ),));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners for Card
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12.0)), // Rounded left corners for image
              child: Image.network(
                Constant.BACKEND_URL + imageUrl,
                width: 120, // Image size
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: ListTile(
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                subtitle: Text(description, style: const TextStyle(color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
