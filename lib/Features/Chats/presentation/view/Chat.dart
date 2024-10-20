import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Auth/presentation/manager/cubit/Shared_bloc/Shared_cubit.dart';
import 'package:our_whatsapp/Features/Chats/presentation/view/widget/addcontact.dart';
import 'package:our_whatsapp/core/helper/Fun.dart';
import 'package:our_whatsapp/core/service/auth_state.dart';
import 'package:our_whatsapp/core/service/cacheHelper.dart';
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
  bool _isSearching = false;
  late bool islight;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    islight = context.read<SharedCubit>().islight;
    log(islight.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Addcontact(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
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
        leading: Icon(
          Icons.add,
          size: 0,
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Chats')
            .where('participants', arrayContains: widget.user.id)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats found.'));
          }

          var filteredUsers = snapshot.data!.docs.where((doc) {
            var chatData = doc.data();
            String username;

            if (chatData['senderid'] == widget.user.id) {
              username = chatData['receivername']?.toLowerCase() ?? '';
            } else {
              username = chatData['sendername']?.toLowerCase() ?? '';
            }

            return username.contains(searchQuery.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              var chat = filteredUsers[index].data();
              return ListTileItem(
                name: chat['senderid'] == widget.user.id
                    ? chat['receivername']
                    : chat['sendername'],
                message: chat['lastmessage'] ?? "",
                time: dateFormat(time: (chat['time'] as Timestamp).toDate()),
                imageUrl: chat['senderid'] == widget.user.id
                    ? chat['receiverimage']
                    : chat['senderimage'],
                onTapProfilePicture: () {
                  showProfilePictureDialog(
                    context,
                    chat['senderid'] == widget.user.id
                        ? chat['receiverimage']
                        : chat['senderimage'],
                  );
                },
                onTapChatItem: () async {
                  DocumentSnapshot<Map<String, dynamic>> data;
                  if (chat['senderid'] == widget.user.id) {
                    data = await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(chat['receiverid'])
                        .get();
                  } else {
                    data = await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(chat['senderid'])
                        .get();
                  }
                  var nextuser = data.data();
                  MyUserData userData = MyUserData.fromJson(nextuser!);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(user: userData),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
