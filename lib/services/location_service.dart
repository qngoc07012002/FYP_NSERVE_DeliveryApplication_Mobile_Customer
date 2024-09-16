import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  final String apiKey = 'PLcr8iHV66JUgWFnOo4bf0oJFe3BaQw1H4Z64I1d'; // Your API Key

  Future<String> getAddressFromCurrentLocation() async {
    try {
      await _checkAndRequestLocationPermission();

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      final response = await http.get(
        Uri.parse('https://rsapi.goong.io/Geocode?latlng=${position.latitude},${position.longitude}&api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          // Trích xuất tên của thành phần địa chỉ đầu tiên
          var firstResult = data['results'][0];
          if (firstResult['address_components'] != null && firstResult['address_components'].isNotEmpty) {
            return firstResult['address_components'][0]['long_name'];
          } else {
            throw Exception('No address components found');
          }
        } else {
          throw Exception('No results found');
        }
      } else {
        throw Exception('Failed to connect to API');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<void> _checkAndRequestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted');
    } else if (status.isDenied) {
      print('Location permission denied');
    } else if (status.isPermanentlyDenied) {
      print('Location permission permanently denied');
      openAppSettings();
    }
  }
}
