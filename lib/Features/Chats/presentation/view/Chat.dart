import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_whatsapp/Features/Chats/presentation/view/NewChat.dart';
import '../../../../core/helper/Fun.dart';
import 'package:our_whatsapp/Features/Chats/data/model/ChatItemData.dart';

import '../../../splash/presentation/view/widget/ChatDetailScreen.dart';
import '../../data/model/userData.dart';
import 'widget/ChatItem.dart';
import 'widget/profile.dart';

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

  @override
  Widget build(BuildContext context) {
    // List<ChatItemData> filteredChatItems = chatItems.where((item) {
    //   return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    // }).toList();

    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyWidget(),
              ),
            );
          },
          icon: Icon(Icons.add)),
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
                    builder: (context) => ProfileScreen(
                      user: widget.user,
                    ),
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
          return ListTileItem(
            name: "eslam",
            message: "message",
            time: DateTime.now().toString(),
            imageUrl: widget.user.image,
            onTapProfilePicture: () {
              showProfilePictureDialog(context, widget.user.image);
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
}
