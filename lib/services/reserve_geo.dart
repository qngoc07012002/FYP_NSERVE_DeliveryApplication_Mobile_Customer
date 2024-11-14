import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  final String apiKey = 'PLcr8iHV66JUgWFnOo4bf0oJFe3BaQw1H4Z64I1d';

  Future<String> getAddressFromCurrentLocation() async {
    try {
      await _checkAndRequestLocationPermission();

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('latitude', position.latitude);
      await prefs.setDouble('longitude', position.longitude);
      
      final response = await http.get(
        Uri.parse('https://rsapi.goong.io/Geocode?latlng=${position.latitude},${position.longitude}&api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          var firstResult = data['results'][0];
          if (firstResult['address_components'] != null && firstResult['address_components'].isNotEmpty) {
           // await prefs.setString('address', firstResult['address_components'][0]['long_name']);
            await prefs.setString('address', firstResult['formatted_address']);
            print("lat: ${position.latitude}" );
            print("lng: ${position.longitude}");
            print("address: ${firstResult['formatted_address']}");
            return firstResult['formatted_address'];
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
