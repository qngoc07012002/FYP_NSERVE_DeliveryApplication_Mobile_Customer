import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../ultilities/Constant.dart';

class WebSocketService extends GetxService {
  StompClient? stompClient;
  Timer? retryTimer;

  @override
  void onInit() {
    super.onInit();
    connect();
  }

  void connect() {
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: Constant.WEBSOCKET_URL,
        webSocketConnectHeaders: {
          'Authorization': 'Bearer ${Constant.JWT}',
        },
        onConnect: onConnect,
        onWebSocketError: (error) => print('WebSocket Error: $error'),
        onStompError: (error) => print('STOMP Error: $error'),
        onDisconnect: (frame) => print('Disconnected from WebSocket server'),
      ),
    );
    stompClient?.activate();
  }

  void onConnect(StompFrame frame) {
    print('Connected to WebSocket server');
    // stompClient?.subscribe(
    //   destination: '/queue/notifications/123',
    //   callback: (StompFrame frame) {
    //     if (frame.body != null) {
    //       print('Received message: ${frame.body}');
    //       showNotificationDialog(frame.body!);
    //     }
    //   },
    // );
  }

  void subscribe(String destination, Function(StompFrame) callback) {
    void trySubscribe() {
      if (stompClient?.connected == true) {
        stompClient?.subscribe(destination: destination, callback: callback);
        print('Subscribed successfully to $destination');
      } else {
        print('WebSocket is not connected, retrying in 5 seconds...');
        Timer(Duration(seconds: 5), trySubscribe);
      }
    }

    trySubscribe();
  }

  void sendMessage(String destination, Map<String, dynamic> body) {
    if (stompClient?.connected == true) {
      stompClient?.send(
        destination: destination,
        body: jsonEncode(body),
      );
      print("Message sent to $destination: ${jsonEncode(body)}");
    } else {
      print("WebSocket is not connected. Unable to send message.");
    }
  }


  void disconnect() {
    stompClient?.deactivate();
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
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
