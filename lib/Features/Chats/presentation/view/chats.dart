import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/ChatItemData.dart';
import '../widget/ChatItem.dart';
import '../../../splash/presentation/view/widget/ChatDetailScreen.dart';

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
      imageUrl:
          'https://th.bing.com/th/id/OIP.5pGmMOmWdCOwrIy_WTIyXQHaJQ?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'Sara Ahmed',
      message: 'See you tomorrow!',
      time: '9:45 AM',
      imageUrl:
          'https://th.bing.com/th/id/OIP.N57sekO4JzTRMUmD5f_ZVgHaEK?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'Mohamed Samir',
      message: 'Can we reschedule?',
      time: 'Yesterday',
      imageUrl:
          'https://th.bing.com/th/id/OIP.5pGmMOmWdCOwrIy_WTIyXQHaJQ?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'Fatma',
      message: 'I sent you the files.',
      time: 'Yesterday',
      imageUrl:
          'https://th.bing.com/th/id/OIP.N57sekO4JzTRMUmD5f_ZVgHaEK?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'John Doe',
      message: 'Let’s catch up soon.',
      time: '2 days ago',
      imageUrl:
          'https://th.bing.com/th/id/OIP.5pGmMOmWdCOwrIy_WTIyXQHaJQ?rs=1&pid=ImgDetMain',
    ),
    ChatItemData(
      name: 'Yassmeen',
      message: 'Don’t forget the meeting!',
      time: '3 days ago',
      imageUrl:
          'https://th.bing.com/th/id/OIP.N57sekO4JzTRMUmD5f_ZVgHaEK?rs=1&pid=ImgDetMain',
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
              _showProfilePictureDialog(
                  context, filteredChatItems[index].imageUrl);
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
