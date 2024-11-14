import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketService {
  StompClient? stompClient;
  final String userId;
  final Function(String) onMessageReceived; // Callback để cập nhật ListView

  WebSocketService(this.userId, this.onMessageReceived);

  // Hàm xử lý khi kết nối thành công
  void onConnect(StompFrame frame) {
    print('Connected to WebSocket server');

    // Subscribe tới queue riêng của user
    stompClient?.subscribe(
      destination: '/queue/notifications/123',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          print('Received message: ${frame.body}');
          onMessageReceived(frame.body!); // Gọi callback để thêm tin nhắn vào ListView
        }
      },
    );
  }

  // Kết nối tới WebSocket server
  void connect() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8080/nserve/ws',
        onConnect: onConnect,
        stompConnectHeaders: {'userId': userId},
        webSocketConnectHeaders: {'userId': userId},
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        onStompError: (dynamic error) => print('STOMP Error: $error'),
        onDisconnect: (frame) => print('Disconnected from WebSocket server'),
      ),
    );

    stompClient?.activate();
  }

  // Ngắt kết nối
  void disconnect() {
    stompClient?.deactivate();
  }
}


