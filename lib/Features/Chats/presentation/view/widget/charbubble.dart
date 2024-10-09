import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding:
            const EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        decoration: BoxDecoration(
          color: Colors.lightGreen[900],
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(32),
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32)),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class ChatRecivedBubble extends StatelessWidget {
  final String message;
  const ChatRecivedBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding:
            const EdgeInsets.only(left: 16, top: 32, bottom: 32, right: 32),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 104, 180, 252),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32)),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
