import 'package:flutter/material.dart';

import '../../data/model/ChatItemData.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatItemDataModel chatItem;

  const ChatDetailScreen({Key? key, required this.chatItem}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = [];

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add(_messageController.text);
        _messageController.clear();
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
              print('Video call pressed');
            },
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              print('Voice call pressed');
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'Settings':
        print('Settings Selected');
        break;
    }
  }
}
