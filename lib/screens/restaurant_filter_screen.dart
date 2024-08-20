import 'package:deliveryapplication_mobile_customer/screens/restaurantdetail_screen.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Pizza', 'Sushi', 'Burgers', 'Salads'];
  final List<Map<String, dynamic>> _stores = [
    {
      'name': 'Pizza Hut',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
      'description': 'Best pizza in town',
      'rating': 4.5,
      'category': 'Pizza',
    },
    {
      'name': 'Sushi Bar',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
      'description': 'Fresh sushi and more',
      'rating': 4.8,
      'category': 'Sushi',
    },
    {
      'name': 'Burger King',
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyFc46glG2RnSW-wnlDZKghM-cmUlqskpIZA&s',
      'description': 'Delicious burgers and fries',
      'rating': 4.3,
      'category': 'Burgers',
    },
  ];

  List<Map<String, dynamic>> _getFilteredStores() {
    return _stores.where((store) {
      final matchesCategory = _selectedCategory == 'All' || store['category'] == _selectedCategory;
      final matchesQuery = store['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
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
            },
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Container(
            color: Colors.white, // Background color for filter section
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: _categories.map((category) {
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
                });
              },
              isExpanded: true,
              underline: Container(), // Remove underline
              icon: Icon(Icons.filter_list, color: Color(0xFF39c5c8)),
              dropdownColor: Colors.white, // Match filter section background
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _getFilteredStores().length,
        itemBuilder: (context, index) {
          final store = _getFilteredStores()[index];
          return _buildStoreItem(
            name: store['name'],
            imageUrl: store['imageUrl'],
            description: store['description'],
            rating: store['rating'],
          );
        },
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
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailPage(),
          ),
        );
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
                imageUrl,
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
