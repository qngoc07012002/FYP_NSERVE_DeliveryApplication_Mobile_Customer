import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';

class NotificationController extends GetxController {
  StompClient? stompClient;
  final messages = <String>[].obs; // Danh sách tin nhắn dùng GetX

  @override
  void onInit() {
    super.onInit();
    connect(); // Kết nối WebSocket khi khởi tạo controller
  }

  // Hàm xử lý khi kết nối thành công
  void onConnect(StompFrame frame) {
    print('Connected to WebSocket server');
    stompClient?.subscribe(
      destination: '/queue/notifications/123',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          print('Received message: ${frame.body}');
          messages.add(frame.body!); // Thêm tin nhắn vào danh sách
          showNotificationDialog(frame.body!); // Hiển thị dialog thông báo
        }
      },
    );
  }

  void showNotificationDialog(String message) {
    // Hiển thị dialog thông báo sử dụng GetX
    Get.defaultDialog(
      title: "Notification",
      content: Text(message),
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }

  // Kết nối WebSocket
  void connect() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8080/nserve/ws',
        onConnect: onConnect,
        onWebSocketError: (error) => print('WebSocket Error: $error'),
        onStompError: (error) => print('STOMP Error: $error'),
        onDisconnect: (frame) => print('Disconnected from WebSocket server'),
      ),
    );
    stompClient?.activate();
  }

  // Ngắt kết nối
  void disconnect() {
    stompClient?.deactivate();
  }

  @override
  void onClose() {
    disconnect(); // Ngắt kết nối khi controller bị hủy
    super.onClose();
  }
}
