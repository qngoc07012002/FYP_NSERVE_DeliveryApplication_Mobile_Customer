import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLocation = "Your Location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Delivery'),
        backgroundColor: Colors.blue,  // Đổi màu theme cho AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pick Location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _pickLocation,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 4.0),
                        Text(
                          selectedLocation,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for food or restaurants',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                onSubmitted: _search,
              ),
              const SizedBox(height: 24.0),

              // Food Categories
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
              const SizedBox(height: 24.0),

              // Stores List
              const Text(
                'Popular Restaurants',
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
      ),
    );
  }

  void _pickLocation() async {
    // Tạo một danh sách các địa điểm giả lập
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
    // Logic tìm kiếm thực tế có thể được thực hiện tại đây
    print('Searching for $query');
    // Ví dụ: Chuyển hướng đến trang kết quả tìm kiếm
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Action khi người dùng nhấn vào một danh mục
        print('Category $title clicked');
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.8),
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
        // Action khi người dùng nhấn vào một cửa hàng
        print('Store $name clicked');
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
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12.0)), // Bo góc trái cho hình ảnh
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
                title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(description),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    Text(rating.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
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
