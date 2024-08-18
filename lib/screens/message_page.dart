import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  final List<Map<String, dynamic>> conversations = [
    {
      'name': 'Cửa Hàng Pizza',
      'avatarUrl': 'https://example.com/store_avatar.png',
      'lastMessage': 'Cảm ơn bạn đã đặt hàng!',
      'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
    },
    {
      'name': 'Người Giao Hàng',
      'avatarUrl': 'https://example.com/delivery_avatar.png',
      'lastMessage': 'Tôi đang trên đường đến nơi!',
      'timestamp': DateTime.now().subtract(Duration(hours: 1)),
    },
    {
      'name': 'Khách Hàng',
      'avatarUrl': 'https://example.com/customer_avatar.png',
      'lastMessage': 'Có thể thay đổi địa chỉ giao hàng không?',
      'timestamp': DateTime.now().subtract(Duration(days: 1)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh Sách Tin Nhắn',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF39c5c8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
        ),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12.0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(conversation['avatarUrl']),
                radius: 30.0,
              ),
              title: Text(
                conversation['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                conversation['lastMessage'],
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                _formatTimestamp(conversation['timestamp']),
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailPage(conversation: conversation),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
