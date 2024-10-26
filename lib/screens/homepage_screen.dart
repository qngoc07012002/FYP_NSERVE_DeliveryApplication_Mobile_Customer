import 'dart:convert';
import 'package:deliveryapplication_mobile_customer/screens/profile_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/restaurant_filter_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/restaurantdetail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../dto/response/RestaurantResponse.dart';
import '../services/reserve_geo.dart';
import '../ultilities/Constant.dart';
import 'bookbike_screen.dart';
import 'locationpicker_screen.dart';
import 'message_screen.dart';
import 'order_screen.dart';

const String apiUrl = Constant.RESTAURANT_URL;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? token;
  String selectedLocation = "Loading...";
  int _selectedIndex = 0;
  final LocationService locationService = LocationService();
  List<RestaurantResponse> restaurants = [];
  @override
  void initState() {
    super.initState();
    _loadToken();
    _updateLocation();
    _fetchRestaurants();


  }



  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt_token');
    print(token);
  }

  Future<void> _updateLocation() async {
    try {
      String location = await locationService.getAddressFromCurrentLocation();
      setState(() {
        selectedLocation = location;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        selectedLocation = 'Cannot get address';
      });
    }
  }

  Future<void> _fetchRestaurants() async {
    try {
      _updateLocation();
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          restaurants = jsonList.map((json) => RestaurantResponse.fromJson(json)).toList();
        });
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          onLocationPicked: (address, lat, lng) {
            setState(()  {
              selectedLocation = address.split(',').first;

              print("lat: ${lat}" );
              print("lng: ${lng}");
              print("address: ${selectedLocation}");
            });
          },
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Selected index: $_selectedIndex');
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchRestaurants,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomePage(),
            RideBookingPage(),
            MessagePage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Bike',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF39c5c8),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePage() {
    return RefreshIndicator(
      onRefresh: _fetchRestaurants,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pick Location & Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF39c5c8),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: _pickLocation,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 4.0),
                        Text(
                          selectedLocation + ' ',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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
                    onSubmitted: _search,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Food Categories
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryItem('Rice', Icons.rice_bowl),
                      _buildCategoryItem('Drink', Icons.local_drink),
                      _buildCategoryItem('Fast Food', Icons.fastfood),
                      _buildCategoryItem('Desserts', Icons.cake),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Stores List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Restaurants',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Use the fetched restaurant data here
                  for (var restaurant in restaurants)
                    _buildStoreItem(
                      name: restaurant.restaurantName,
                      imageUrl: restaurant.imgUrl,
                      description: restaurant.description,
                      rating: restaurant.rating,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _search(String query) {
    print('Searching for $query');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage(),
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        print('Category $title clicked');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilterPage(),
          ),
        );
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

  Widget _buildStoreItem({
    required String name,
    required String imageUrl,
    required String description,
    required double rating,
  }) {
    return GestureDetector(
      onTap: () {
        print('Store $name clicked');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailPage(),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.network(
                Constant.IMAGE_URL + imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/food_image.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  );
                },
              ),

              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4.0),
                        Text(rating.toString()),
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
