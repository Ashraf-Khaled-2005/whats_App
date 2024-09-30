import 'package:flutter/material.dart';

import '../../../../Chats/presentation/view/chats.dart';
import '../../../../Chats/model/ChatItemData.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatItemData chatItem;

  const ChatDetailScreen({Key? key, required this.chatItem}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = []; // قائمة الرسائل

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add(_messageController.text); // إضافة الرسالة إلى القائمة
        _messageController.clear(); // مسح حقل الإدخال
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.chatItem.imageUrl),
                radius: 20,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.chatItem.name,
                      style: const TextStyle(fontSize: 16)),
                  const Text("online",
                      style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // حدث لمكالمة الفيديو
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // حدث للمكالمة الصوتية
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // المزيد من الخيارات
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(messages[index]), // عرض الرسالة
                    subtitle: Text('Just now'), // الوقت الافتراضي
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage, // إرسال الرسالة
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
