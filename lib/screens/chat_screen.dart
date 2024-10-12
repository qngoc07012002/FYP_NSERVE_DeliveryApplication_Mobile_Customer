import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:convert';

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  StompClient? stompClient;
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  void connectToWebSocket() {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://192.168.56.2:8080/spring-boot-tutorial', // Adjusted WebSocket URL
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );

    stompClient!.activate();
    print("Connect Success");
  }

  void onConnect(StompFrame frame) {
    stompClient!.subscribe(
      destination: '/topic/greetings',  // Adjusted to match the Spring Boot destination
      callback: (StompFrame frame) {
        if (frame.body != null) {
          setState(() {
            messages.add(frame.body!);  // Add received message to the list
          });
        }
      },
    );
  }

  void sendMessage(String message) {
    stompClient!.send(
      destination: '/app/hello',  // Adjusted to match the Spring Boot endpoint
      body: json.encode({'name': message}),  // Adjusted to send the name in the correct format
    );
    _controller.clear();  // Clear the input field after sending
    print("Send Success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index]),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Enter your name'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        sendMessage(_controller.text);
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    stompClient?.deactivate();
    super.dispose();
  }
}
