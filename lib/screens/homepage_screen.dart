import 'package:deliveryapplication_mobile_customer/screens/profile_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/restaurant_filter_screen.dart';
import 'package:deliveryapplication_mobile_customer/screens/restaurantdetail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'bookbike_screen.dart';
import 'message_screen.dart';
import 'order_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLocation = "Your Location";
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Here you can handle navigation logic based on the selected index
      print('Selected index: $_selectedIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomePage(), // The home page content
          RideBookingPage(),
          MessagePage(),
          ProfilePage(),
        ],
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pick Location & Search Bar
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF39c5c8), // Màu xanh chủ đạo
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20.0), // Bo tròn góc dưới
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
                        selectedLocation,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.white),
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
                    _buildCategoryItem('Pizza', Icons.local_pizza),
                    _buildCategoryItem('Sushi', Icons.ramen_dining),
                    _buildCategoryItem('Burgers', Icons.fastfood),
                    _buildCategoryItem('Salads', Icons.local_dining),
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
                _buildStoreItem(
                  name: 'Pizza Hut',
                  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
                  description: 'Best pizza in town',
                  rating: 4.5,
                ),
                _buildStoreItem(
                  name: 'Sushi Bar',
                  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
                  description: 'Fresh sushi and more',
                  rating: 4.8,
                ),
                _buildStoreItem(
                  name: 'Burger King',
                  imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
                  description: 'Delicious burgers and fries',
                  rating: 4.3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pickLocation() async {
    List<String> locations = ['Hanoi', 'Ho Chi Minh City', 'Da Nang', 'Hai Phong'];
    String? picked = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: locations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(locations[index]),
              onTap: () {
                Navigator.pop(context, locations[index]);
              },
            );
          },
        );
      },
    );

    if (picked != null && picked.isNotEmpty) {
      setState(() {
        selectedLocation = picked;
      });
    }
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Bo góc cho Card
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12.0)), // Bo góc trái cho hình ảnh
              child: Image.network(
                imageUrl,
                width: 120, // Kích thước hình ảnh
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: ListTile(
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(description),
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

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}
