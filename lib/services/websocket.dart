import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late StompClient stompClient;

  void connect() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://10.0.2.2:8080/websocket',
        onConnect: (StompFrame frame) {
          print('Connected to WebSocket');
          // Subscribe to public topic
          stompClient.subscribe(
            destination: '/topic/public',
            callback: (StompFrame frame) {
              // Handle incoming messages
              print('Received message: ${frame.body}');
            },
          );
        },
        onWebSocketError: (dynamic error) {
          print('WebSocket error: $error');
          // Optionally, you could attempt to reconnect here
        },
        onStompError: (StompFrame frame) {
          print('Stomp error: ${frame.body}');
        },
      ),
    );

    stompClient.activate();
  }


  void sendMessage(String sender, String message) {
    final chatMessage = {
      'sender': sender,
      'content': message,
      'type': 'CHAT',
    };

    stompClient.send(
      destination: '/app/chat.send',
      body: jsonEncode(chatMessage),
    );
  }

  void dispose() {
    stompClient.deactivate();
  }
}
