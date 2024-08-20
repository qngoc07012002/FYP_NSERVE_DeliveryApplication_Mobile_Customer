import 'package:deliveryapplication_mobile_customer/screens/placeorder_screen.dart';
import 'package:flutter/material.dart';

class RestaurantDetailPage extends StatefulWidget {
  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  num _totalAmount = 0;
  List<Map<String, dynamic>> dishes = [
    {
      'name': 'Margherita Pizza',
      'image': 'https://statics.vinpearl.com/pho-nha-trang-10_1672152440.jpg',
      'price': 10.00,
      'quantity': 0,
    },
    {
      'name': 'Sushi Platter',
      'image': 'https://cdn.tgdd.vn/Files/2020/05/20/1256908/troi-mua-thu-lam-banh-xeo-kieu-mien-bac-gion-ngon-it-dau-mo-202005201034115966.jpg',
      'price': 15.00,
      'quantity': 0,
    },
    {
      'name': 'Caesar Salad',
      'image': 'https://images2.thanhnien.vn/528068263637045248/2023/5/22/goi-cuon-16847338256841687509788.jpeg',
      'price': 8.00,
      'quantity': 0,
    },
    {
      'name': 'Caesar Salad',
      'image': 'https://cdn.pastaxi-manager.onepas.vn/content/uploads/articles/01-le/top-8-dac-san-viet-nam/hinh-8-com-tam-sai-gon-la-mon-an-dan-da-cua-nguoi-dan-sai-thanh.jpg',
      'price': 8.00,
      'quantity': 0,
    },
    {
      'name': 'Caesar Salad',
      'image': 'https://saodieu.vn/media/Bai%20Viet%20-%20T62016/Saodieu%20-%2010%20mon%20an%201.jpg',
      'price': 8.00,
      'quantity': 0,
    },
    {
      'name': 'Caesar Salad',
      'image': 'https://mcdn.coolmate.me/image/September2023/mon-an-ngon-truyen-thong-viet-nam-de-lam_144.jpg',
      'price': 8.00,
      'quantity': 0,
    },
    {
      'name': 'Caesar Salad',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjbygIPcOVww00Bj9VES793XZfcmUf4Ix_dQ&s',
      'price': 8.00,
      'quantity': 0,
    },
  ];

  void _increaseQuantity(int index) {
    setState(() {
      dishes[index]['quantity']++;
      _totalAmount += dishes[index]['price'];
    });
  }

  void _decreaseQuantity(int index) {
    if (dishes[index]['quantity'] > 0) {
      setState(() {
        dishes[index]['quantity']--;
        _totalAmount -= dishes[index]['price'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Detail', style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: Column(
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
                    'https://cdn.tgdd.vn/Files/2020/05/20/1256908/troi-mua-thu-lam-banh-xeo-kieu-mien-bac-gion-ngon-it-dau-mo-202005201034115966.jpg',
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
                      const Text(
                        'Pizza Hut',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      const Text(
                        'Best pizza in town',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4.0),
                          const Text(
                            '4.5',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
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
                          dishes[index]['image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            dishes[index]['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('\$${dishes[index]['price']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _decreaseQuantity(index),
                              ),
                              Text('${dishes[index]['quantity']}'),
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
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          print("On Tap Total Price");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderSummaryPage(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF39c5c8),
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
                  color: Colors.white,
                ),
              ),
              Text(
                '\$${_totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

        ),
      )
    );
  }
}

void main() => runApp(MaterialApp(home: RestaurantDetailPage()));
