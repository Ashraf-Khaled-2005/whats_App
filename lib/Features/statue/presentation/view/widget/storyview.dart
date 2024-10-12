import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import '../../../data/model/statusModel.dart';

class StoryPageView extends StatefulWidget {
  final List<StatueModel> userStories;
  const StoryPageView({super.key, required this.userStories});

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    List<StoryItem> storyItemslist = widget.userStories.map((story) {
      if (story.imageurl == null) {
        return StoryItem.pageVideo(
          story.videourl!,
          controller: controller,
          caption: Text(story.caption ?? '',
              style: const TextStyle(color: Colors.white)),
        );
      } else {
        return StoryItem.pageImage(
          url: story.imageurl!,
          controller: controller,
          caption: Text(story.caption ?? '',
              style: const TextStyle(color: Colors.white)),
        );
      }
    }).toList();

    return Material(
      child: StoryView(
        storyItems: storyItemslist,
        controller: controller,
        inline: false,
        repeat: false,
        onStoryShow: (storyItem, index) {},
        onComplete: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
