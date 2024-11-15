import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

import '../services/websocket_service.dart';

class NotificationController extends GetxController {
  final WebSocketService _webSocketService = Get.find();
  final messages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _webSocketService.subscribe(
      '/queue/notifications/123',
          (frame) {
        if (frame.body != null) {
          print('Received message: ${frame.body}');
          messages.add(frame.body!);
          showNotificationDialog(frame.body!);
        }
      },
    );
  }

  void showNotificationDialog(String message) {
    Get.defaultDialog(
      title: "Notification",
      content: Text(message),
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }
}
