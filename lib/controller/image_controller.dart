import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../ultilities/Constant.dart';
import 'package:http_parser/http_parser.dart';

class ImageController extends GetxController {
  var isLoading = false.obs;

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      isLoading(true);
      String token = await getToken();

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constant.BACKEND_URL}/files/upload'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      final mimeType = lookupMimeType(imageFile.path);
      final contentType = MediaType.parse(mimeType!);

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: contentType,
      ));

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody.body);
        if (data['code'] == 1000) {
          return data['result']['path'];
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      isLoading(false);
    }
    return null;
  }
}