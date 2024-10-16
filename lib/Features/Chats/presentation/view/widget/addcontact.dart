import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';
import 'ChatItem.dart';
import 'Chat_Detail.dart';

class Addcontact extends StatefulWidget {
  const Addcontact({super.key});

  @override
  State<Addcontact> createState() => _AddcontactState();
}

class _AddcontactState extends State<Addcontact> {
  String searchQuery = "";
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              : const Text("Start Chatting",
                  style: TextStyle(color: Colors.white)),
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
        body: Column(
          children: [
            const SizedBox(height: 30),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('Users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong! ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Handle empty state
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No chats available'),
                  );
                }
                var filteredUsers = snapshot.data!.docs.where((doc) {
                  var chatData = doc.data();
                  var username = chatData['username']?.toLowerCase() ?? '';
                  var mobile = chatData['phone']?.toLowerCase() ?? '';

                  return username.contains(searchQuery) ||
                      mobile.contains(searchQuery); // Filter based on search
                }).toList();
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: 30,
                        width: double.infinity,
                        child: const Text("Contacts on whatsApp",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w100,
                            )),
                      ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            var chatData = filteredUsers[index].data();
                            MyUserData user = MyUserData(
                                image: chatData['image'],
                                username: chatData['username'],
                                email: chatData['email'],
                                phone: chatData['phone'],
                                id: chatData['id'],
                                ids: chatData['chatsid']);
                            return ListTileItem(
                              onTapChatItem: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatDetailScreen(
                                      user: user,
                                    ),
                                  ),
                                );
                              },
                              onTapProfilePicture: () {},
                              name: chatData['username'],
                              message:
                                  (chatData['phone'] as String).substring(1),
                              time: "",
                              imageUrl: chatData['image'],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
