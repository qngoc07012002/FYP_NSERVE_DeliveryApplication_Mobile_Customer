import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket Echo Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebSocketEchoPage(),
    );
  }
}

class WebSocketEchoPage extends StatefulWidget {
  @override
  _WebSocketEchoPageState createState() => _WebSocketEchoPageState();
}

class _WebSocketEchoPageState extends State<WebSocketEchoPage> {
  final TextEditingController _controller = TextEditingController();
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.org'), // Địa chỉ WebSocket Echo Server
  );

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Echo Test'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return ListView(
                  children: [
                    if (snapshot.hasData) ...[
                      ListTile(
                        title: Text(snapshot.data.toString()),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Send a message',
                    ),
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
