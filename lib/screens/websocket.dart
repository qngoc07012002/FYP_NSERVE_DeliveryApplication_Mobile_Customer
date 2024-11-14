import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: ChatRoom(),
    );
  }
}

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late StompClient stompClient;
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    // Cấu hình STOMP Client
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8080/nserve/ws', // Đảm bảo rằng URL này là đúng
        stompConnectHeaders: {'userId': "123"},
        webSocketConnectHeaders: {'userId': "123"},
        onConnect: onConnectCallback,
        onWebSocketError: (dynamic error) => print('WebSocket error: $error'),
      ),
    );

    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    print('Connected');
    stompClient.subscribe(
      destination: '/topic/messages',
      callback: (StompFrame frame) {
        setState(() {
          messages.add(ChatMessage.fromJson(frame.body!));
        });
      },
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = ChatMessage(sender: 'User', content: _controller.text);
      stompClient.send(
        destination: '/app/send',
        body: message.toJson(),
      );
      _controller.clear();
    }
  }

  @override
  void dispose() {
    stompClient.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].content),
                  subtitle: Text(messages[index].sender),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String content;

  ChatMessage({required this.sender, required this.content});

  factory ChatMessage.fromJson(String json) {
    final data = jsonDecode(json);
    return ChatMessage(
      sender: data['sender'],
      content: data['content'],
    );
  }

  String toJson() {
    return jsonEncode({'sender': sender, 'content': content});
  }
}
