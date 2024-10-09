import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';

import 'ChatItem.dart';
import 'Chat_Detail.dart';

class Addcontact extends StatelessWidget {
  Addcontact({super.key});
  List New = const [
    {
      "image":
          "https://cdn.stocksnap.io/img-thumbs/960w/mountains-clouds_A4Y2Q66EL4.jpg",
      "name": "New group",
    },
    {
      "image":
          "https://cdn.create.vista.com/api/media/small/8099055/stock-photo-autumnal-natural-background",
      "name": "New contact",
    },
    {
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiYdLgEeNF0dmf4tC2me4zMZpEQBVJwyv6ta6T1qgsrg&s",
      "name": "New comuntiy",
    }
  ];
  List chats = [
    {
      "image":
          "https://cdn.stocksnap.io/img-thumbs/960w/mountains-clouds_A4Y2Q66EL4.jpg",
      "name": "(you)"
    },
    {
      "image":
          "https://cdn.create.vista.com/api/media/small/8099055/stock-photo-autumnal-natural-background",
      "name": "01256374527"
    },
    {
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRiYdLgEeNF0dmf4tC2me4zMZpEQBVJwyv6ta6T1qgsrg&s",
      "name": "012e6364263"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Select contact',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 30),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('Users').snapshots(),
              builder: (context, snapshot) {
                // Handle error state
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Something went wrong! ${snapshot.error}'),
                  );
                }

                // Handle loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Handle empty state
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No chats available'),
                  );
                }

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
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var chatData = snapshot.data!.docs[index].data();
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
