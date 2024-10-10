import 'package:flutter/material.dart';
import 'package:our_whatsapp/Features/Chats/data/model/MessageModel.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';

import '../../../../../core/helper/Fun.dart';

class ChatBubble extends StatelessWidget {
  final MyUserData OwnUser, user2;
  final MessageModel message;
  const ChatBubble({
    super.key,
    required this.message,
    required this.OwnUser,
    required this.user2,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(OwnUser.image),
            radius: 20,
          ),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.only(
                    left: 16, top: 16, bottom: 16, right: 32),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[900],
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(32),
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                ),
                child: Text(
                  message.message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Text(
                dateFormat(time: message.time),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatRecivedBubble extends StatelessWidget {
  final MessageModel message;
  final MyUserData OwnUser, user2;

  const ChatRecivedBubble(
      {super.key,
      required this.message,
      required this.OwnUser,
      required this.user2});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.only(
                    left: 16, top: 16, bottom: 16, right: 32),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 104, 180, 252),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32)),
                ),
                child: Text(
                  message.message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Text(
                dateFormat(time: message.time),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(OwnUser.image),
            radius: 20,
          ),
        ],
      ),
    );
  }
}
