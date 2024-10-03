import 'package:get/get.dart';
import 'package:story_view/story_view.dart';
import 'package:flutter/material.dart';
import 'package:statuspart/status/liststatus.dart';

class StoryPageView extends StatefulWidget {
  const StoryPageView({super.key});

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final controller = StoryController();

  List<StoryItem> storyItemslist=[
    StoryItem.text(title: chats[1]['name'], backgroundColor: Colors.blueAccent),
    StoryItem.pageImage(url: 'https://cdn.create.vista.com/api/media/small/8099055/stock-photo-autumnal-natural-background', controller: StoryController()),
    StoryItem.pageVideo("https://www.youtube.com/watch?v=ilX5hnH8XoI", controller: StoryController()),

  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: StoryView(
         storyItems: storyItemslist,
        controller: controller,
        inline: false,
        repeat: false,
      ),
    );
  }
}
