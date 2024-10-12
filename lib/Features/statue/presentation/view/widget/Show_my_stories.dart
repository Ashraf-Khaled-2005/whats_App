import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:our_whatsapp/Features/statue/data/model/statusModel.dart';

import 'storyview.dart';

class ShowMyStories extends StatefulWidget {
  final List<StatueModel> list;

  const ShowMyStories({super.key, required this.list});

  @override
  State<ShowMyStories> createState() => _ShowMyStoriesState();
}

class _ShowMyStoriesState extends State<ShowMyStories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const Icon(Icons.search),
          title: const Text(
            'My Status',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff075e54)),
      body: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            return ListTile(
              trailing: IconButton(
                  onPressed: () async {
                    await deleteStory(id: widget.list[index].id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Story Deleted"),
                      ),
                    );
                    setState(() {
                      widget.list.removeAt(index);
                    });
                  },
                  icon: const Icon(Icons.delete)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StoryPageView(userStories: [widget.list[index]]),
                  ),
                );
              },
              title: Text(widget.list[0].username),
              subtitle: const Text('Tap to view Story'),
              leading: AdvancedAvatar(
                image: NetworkImage(widget.list[0].userimage),
                foregroundDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 3),
                ),
                size: 45,
              ),
            );
          }),
    );
  }
}

deleteStory({required String id}) async {
  await FirebaseFirestore.instance.collection('Stories').doc(id).delete();
}

deleteAfter24({required StatueModel model}) {
  Duration diff = DateTime.now().difference(model.time);
  if (diff.inHours >= 24) {
    deleteStory(id: model.id);
  }
}
