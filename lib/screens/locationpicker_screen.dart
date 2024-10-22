import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key, required this.onLocationPicked});

  final void Function(String, double, double) onLocationPicked;

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  List<dynamic> places = [];
  final TextEditingController _searchController = TextEditingController();
  bool isShow = false;

  Future<void> fetchData(String input) async {
    try {
      final url = Uri.parse(
        'https://rsapi.goong.io/Place/AutoComplete?api_key=PLcr8iHV66JUgWFnOo4bf0oJFe3BaQw1H4Z64I1d&input=$input',
      );

      final response = await http.get(url);

      setState(() {
        final jsonResponse = jsonDecode(response.body);
        places = jsonResponse['predictions'] as List<dynamic>;
        isShow = true;
      });
    } catch (e) {
      print('$e');
    }
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final coordinate = places[index];

        return Card(

          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            leading: const Icon(
              Icons.location_on_outlined,
              color: Colors.blue,
              size: 28,
            ),
            title: Text(
              coordinate['description'],
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Hiển thị tối đa 2 dòng trước khi bị cắt ngắn
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            onTap: () async {
              final url = Uri.parse(
                'https://rsapi.goong.io/geocode?address=${coordinate['description']}&api_key=PLcr8iHV66JUgWFnOo4bf0oJFe3BaQw1H4Z64I1d',
              );
              var response = await http.get(url);
              final jsonResponse = jsonDecode(response.body);
              final details = jsonResponse['results'] as List<dynamic>;

              if (details.isNotEmpty) {
                final location = details[0]['geometry']['location'];

                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('latitude', coordinate['description']);
                await prefs.setDouble('latitude', location['lat']);
                await prefs.setDouble('address', location['lng']);

                widget.onLocationPicked(
                  coordinate['description'],
                  location['lat'],
                  location['lng'],
                );
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF39c5c8),
        title: const Text(
          'Pick Location',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        toolbarHeight: 80.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    fetchData(text);
                  } else {
                    setState(() {
                      isShow = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF39c5c8)),
                  hintText: "Enter address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: isShow
                  ? _buildListView()
                  : const Center(child: Text("No results")),
            ),
          ],
        ),
      ),
    );
  }
}
