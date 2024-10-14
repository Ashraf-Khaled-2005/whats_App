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
          icon: const Icon(Icons.add)),
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
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('Chats')
                .where('participants', arrayContains: widget.user.id)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: const Text('No chats found.'));
              }
              var result = snapshot.data!.docs;

              return ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return ListTileItem(
                    name: result[index]['senderid'] == widget.user.id
                        ? result[index]['receivername']
                        : result[index]['sendername'],
                    message: result[index]['lastmessage'] ?? "",
                    time: (result[index]['time'] as Timestamp)
                        .toDate()
                        .toString(),
                    imageUrl: result[index]['senderid'] == widget.user.id
                        ? result[index]['receiverimage']
                        : result[index]['senderimage'],
                    onTapProfilePicture: () {
                      showProfilePictureDialog(
                          context,
                          result[index]['senderid'] == widget.user.id
                              ? result[index]['receiverimage']
                              : result[index]['senderimage']);
                    },
                    onTapChatItem: () async {
                      DocumentSnapshot<Map<String, dynamic>> data;
                      if (result[index]['senderid'] == widget.user.id) {
                        data = await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(result[index]['receiverid'])
                            .get();
                      } else {
                        data = await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(result[index]['senderid'])
                            .get();
                      }
                      var nextuser = data.data();
                      MyUserData userData = MyUserData.fromJson(nextuser!);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatDetailScreen(user: userData),
                          ));
                    },
                  );
                },
              );
            }),
      ),
    );
  }
}
