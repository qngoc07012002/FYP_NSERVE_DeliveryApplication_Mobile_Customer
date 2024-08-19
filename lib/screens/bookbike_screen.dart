import 'package:flutter/material.dart';

class RideBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Placeholder image at the bottom layer
          Positioned.fill(
            child: Image.asset(
              'assets/sample_map.jpg', // Replace with your own image path
              fit: BoxFit.cover,
            ),
          ),

          // Location selection (top)
          Positioned(
            top: 50.0,
            left: 16.0,
            right: 16.0,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Starting Point',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.location_on, color: Color(0xFF39c5c8)),
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Destination',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.location_on, color: Color(0xFF39c5c8)),
                  ),
                ),
              ],
            ),
          ),

          // Vehicle selection (bottom)
          Positioned(
            bottom: 20.0,
            left: 16.0,
            right: 16.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildVehicleOption(Icons.motorcycle, 'Motorbike', true),
                  _buildVehicleOption(Icons.directions_car, 'Car', false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleOption(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Handle vehicle selection
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xFF39c5c8) : Colors.grey,
            size: 30.0,
          ),
          SizedBox(height: 4.0),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Color(0xFF39c5c8) : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
