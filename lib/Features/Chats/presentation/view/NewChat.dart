import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'widget/ChatItem.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
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

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              thickness: 2,
              color: Colors.white,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var chatData = snapshot.data!.docs[index].data();

              return ListTileItem(
                onTapChatItem: () {},
                onTapProfilePicture: () {},
                name: chatData['username'],
                message: (chatData['phone'] as String).substring(1),
                time: "",
                imageUrl: chatData['image'],
              );
            },
          );
        },
      ),
    );
  }
}
