import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getRoomId({required String id1, required String id2}) {
  List<String> l = [id1, id2];
  l.sort();
  return '${l[0]}_${l[1]}';
}

String dateFormat({required DateTime time}) {
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(time);
  return formattedDate;
}

void showProfilePictureDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat, color: Colors.white),
                  onPressed: () {
                    print('Chat icon pressed');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    print('Info icon pressed');
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
