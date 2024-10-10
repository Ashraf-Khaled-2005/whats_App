import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/GetUserDataCubit/get_user_data_cubit.dart';
import 'package:our_whatsapp/Features/Chats/presentation/view/widget/addcontact.dart';
import '../../../../core/helper/Fun.dart';
import '../../data/model/userData.dart';
import 'widget/ChatItem.dart';
import 'widget/Chat_Detail.dart';
import 'widget/profile.dart';

class ChatScreen extends StatefulWidget {
  final MyUserData user;

  const ChatScreen({super.key, required this.user});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String searchQuery = "";
  final ImagePicker _picker = ImagePicker();
  bool _isSearching = false;
  late Future<List<MyUserData>> futureChatUsers;

  Future<List<MyUserData>> getUserChats(String userId) async {
    DocumentSnapshot currentUserDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    List<dynamic>? messagingUserIds = currentUserDoc['ids'];

    if (messagingUserIds == null || messagingUserIds.isEmpty) {
      return [];
    }

    List<MyUserData> chatUsers = [];
    for (String userId in messagingUserIds) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();

      MyUserData userData = MyUserData(
        id: userDoc.id,
        username: userDoc['username'],
        image: userDoc['image'],
        email: userDoc['email'],
        phone: userDoc['phone'],
        ids: userDoc['ids'],
      );

      chatUsers.add(userData);
    }

    return chatUsers;
  }

  Future<void> _refreshChatList() async {
    setState(() {
      futureChatUsers = getUserChats(widget.user.id); // Refresh the future
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureChatUsers = getUserChats(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    // List<ChatItemData> filteredChatItems = chatItems.where((item) {
    //   return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    // }).toList();

    return Scaffold(
      floatingActionButton: IconButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Addcontact(),
              ),
            );
            _refreshChatList();
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
      body: RefreshIndicator(
        onRefresh: _refreshChatList,
        child: FutureBuilder<List<MyUserData>>(
            future: getUserChats(context.read<GetUserDataCubit>().userData.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No chats found.'));
              }
              List<MyUserData> UsersChats = snapshot.data!;

              return ListView.builder(
                itemCount: UsersChats.length,
                itemBuilder: (context, index) {
                  return ListTileItem(
                    name: UsersChats[index].username,
                    message: "message",
                    time: DateTime.now().toString(),
                    imageUrl: UsersChats[index].image,
                    onTapProfilePicture: () {
                      showProfilePictureDialog(
                          context, UsersChats[index].image);
                    },
                    onTapChatItem: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            user: UsersChats[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}
