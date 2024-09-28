import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatItemData> chatItems = [
    ChatItemData(
      name: 'Ahmed Ali',
      message: 'Hey! How are you?',
      time: '10:30 AM',
      imageUrl: 'https://th.bing.com/th/id/OIP.5pGmMOmWdCOwrIy_WTIyXQHaJQ?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'Sara Ahmed',
      message: 'See you tomorrow!',
      time: '9:45 AM',
      imageUrl: 'https://th.bing.com/th/id/OIP.N57sekO4JzTRMUmD5f_ZVgHaEK?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'Mohamed Samir',
      message: 'Can we reschedule?',
      time: 'Yesterday',
      imageUrl: 'https://th.bing.com/th/id/OIP.5pGmMOmWdCOwrIy_WTIyXQHaJQ?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'Fatma',
      message: 'I sent you the files.',
      time: 'Yesterday',
      imageUrl: 'https://th.bing.com/th/id/OIP.N57sekO4JzTRMUmD5f_ZVgHaEK?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'John Doe',
      message: 'Let’s catch up soon.',
      time: '2 days ago',
      imageUrl: 'https://th.bing.com/th/id/OIP.5pGmMOmWdCOwrIy_WTIyXQHaJQ?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'Yassmeen',
      message: 'Don’t forget the meeting!',
      time: '3 days ago',
      imageUrl: 'https://th.bing.com/th/id/OIP.N57sekO4JzTRMUmD5f_ZVgHaEK?rs=1&pid=ImgDetMain',
    ),
  ];

  String searchQuery = "";
  final ImagePicker _picker = ImagePicker();
  bool _isSearching = false; // Track if search is active

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print('Image Path: ${image.path}');
    }
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'Settings':
        print('Settings Selected');
        break;
      case 'New Group':
        print('New Group Selected');
        break;
      case 'New Broadcast':
        print('New Broadcast Selected');
        break;
      case 'Starred Messages':
        print('Starred Messages Selected');
        break;
      case 'Logout':
        print('Logout Selected');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ChatItemData> filteredChatItems = chatItems.where((item) {
      return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        )
            : const Text("WhatsApp", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        actions: [
          if (!_isSearching) ...[
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: _openCamera,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true; // Activate search
                  searchQuery = ""; // Clear search when starting
                });
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: _handleMenuSelection,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'New Group',
                    child: Text('New Group'),
                  ),
                  const PopupMenuItem(
                    value: 'New Broadcast',
                    child: Text('New Broadcast'),
                  ),
                  const PopupMenuItem(
                    value: 'Starred Messages',
                    child: Text('Starred Messages'),
                  ),
                  const PopupMenuItem(
                    value: 'Settings',
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem(
                    value: 'Logout',
                    child: Text('Logout'),
                  ),
                ];
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false; // Deactivate search
                  searchQuery = ""; // Clear search
                });
              },
            ),
          ],
        ],
      ),
      body: ListView.builder(
        itemCount: filteredChatItems.length,
        itemBuilder: (context, index) {
          return ChatItem(
            name: filteredChatItems[index].name,
            message: filteredChatItems[index].message,
            time: filteredChatItems[index].time,
            imageUrl: filteredChatItems[index].imageUrl,
            onTapProfilePicture: () {
              _showProfilePictureDialog(context, filteredChatItems[index].imageUrl);
            },
            onTapChatItem: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    chatItem: filteredChatItems[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showProfilePictureDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chat, color: Colors.white),
                    onPressed: () {
                      print('Chat icon pressed');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    onPressed: () {
                      print('Info icon pressed');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

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
                  Text(widget.chatItem.name, style: const TextStyle(fontSize: 16)),
                  const Text("online", style: TextStyle(fontSize: 12, color: Colors.white70)),
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

class ChatItemData {
  final String name;
  final String message;
  final String time;
  final String imageUrl;

  ChatItemData({required this.name, required this.message, required this.time, required this.imageUrl});
}

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String imageUrl;
  final VoidCallback onTapProfilePicture;
  final VoidCallback onTapChatItem;

  const ChatItem({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    required this.imageUrl,
    required this.onTapProfilePicture,
    required this.onTapChatItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: onTapProfilePicture,
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
      title: Text(name),
      subtitle: Text(message),
      trailing: Text(time),
      onTap: onTapChatItem,
    );
  }
}
