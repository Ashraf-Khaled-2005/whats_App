import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_whatsapp/Features/Chats/data/model/ChatItemData.dart';

import '../../../splash/presentation/view/widget/ChatDetailScreen.dart';
import '../../data/model/userData.dart';
import '../widget/ChatItem.dart';
import '../widget/profile.dart';

class ChatScreen extends StatefulWidget {
  final UserData user;

  const ChatScreen({super.key, required this.user});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String searchQuery = "";
  final ImagePicker _picker = ImagePicker();
  bool _isSearching = false;

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print('Image Path: ${image.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<ChatItemData> filteredChatItems = chatItems.where((item) {
    //   return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    // }).toList();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                style: const TextStyle(color: Colors.white),
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
                  _isSearching = true;
                  searchQuery = "";
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: widget.user,),
                  ),
                );
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  searchQuery = "";
                });
              },
            ),
          ],
        ],
        leading: null,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ChatItem(
            name: "eslam",
            message: "message",
            time: DateTime.now().toString(),
            imageUrl: widget.user.image,
            onTapProfilePicture: () {
              _showProfilePictureDialog(context, widget.user.image);
            },
            onTapChatItem: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    chatItem: ChatItemDataModel(
                        name: widget.user.username,
                        message: "message",
                        time: DateTime.now().toString(),
                        imageUrl: widget.user.image),
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
