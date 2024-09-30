import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final String imageUrl;
  final VoidCallback onTapProfilePicture;
  final VoidCallback onTapChatItem;

  const ChatItem({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    required this.imageUrl,
    required this.onTapProfilePicture,
    required this.onTapChatItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: onTapProfilePicture,
        child: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
      title: Text(name),
      subtitle: Text(message),
      trailing: Text(time),
      onTap: onTapChatItem,
    );
  }
}
