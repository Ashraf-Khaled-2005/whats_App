import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Auth/presentation/view/login/custom_widget/custom_text_field.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/GetUserDataCubit/get_user_data_cubit.dart';
import 'package:our_whatsapp/Features/statue/data/model/statusModel.dart';
import 'package:our_whatsapp/Features/statue/presentation/view/widget/Show_my_stories.dart';
import 'package:our_whatsapp/core/helper/imagepick.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class Addstory extends StatefulWidget {
  const Addstory({super.key});

  @override
  State<Addstory> createState() => _AddstoryState();
}

class _AddstoryState extends State<Addstory> {
  late TextEditingController controller;
  VideoPlayerController? videocontroller;
  bool isloading = false;
  String? des;
  File? video;
  File? image;
  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: isloading
          ? CircularProgressIndicator()
          : FloatingActionButton(
              onPressed: _sendStory,
              child: const Icon(Icons.send),
            ),
      appBar: AppBar(
        title: const Text("Add Story"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            image != null
                ? Image.file(
                    image!,
                    height: h * .3,
                    fit: BoxFit.fill,
                  )
                : video != null
                    ? SizedBox(
                        height: h * .3,
                        width: w,
                        child: VideoPlayer(videocontroller!),
                      )
                    : SizedBox(
                        height: h * .3,
                      ),
            PopupMenuButton(
              icon: const Icon(Icons.upload),
              onSelected: (value) async {
                if (value == 'Image') {
                  if (value == 'Image') {
                    if (videocontroller != null) {
                      await videocontroller!.pause();
                    }
                    image = await pickImageGallery();
                    setState(() {});
                  }
                }
                if (value == 'Video') {
                  video = await pickVideoGallery();
                  if (video != null) {
                    videocontroller = VideoPlayerController.file(video!);
                    await videocontroller!.initialize();
                    await videocontroller!.play();
                    setState(() {
                      image = null;
                    });
                  }
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'Image',
                    child: Text("Image"),
                  ),
                  const PopupMenuItem(
                    value: "Video",
                    child: Text("Video"),
                  ),
                ];
              },
            ),
            CustomTextField(
              validator: (value) {},
              controller: controller,
              hintText: "Caption",
            )
          ],
        ),
      ),
    );
  }

  _sendStory() async {
    setState(() {
      isloading = true;
    });
    log('begin');
    final uuid = const Uuid().v4();
    String? imageurl;
    String? vidurl;
    if (image != null) {
      imageurl = await getImgaeUrl(uuid, image!, "Story");
    } else {
      vidurl = await getImgaeUrl(uuid, video!, "Story");
    }

    var user = context.read<GetUserDataCubit>().userData;
    StatueModel model = StatueModel(
        id: uuid,
        time: DateTime.now(),
        caption: "caption",
        userid: "userid",
        imageurl: "imageurl",
        videourl: "videourl",
        views: [],
        userimage: "userimage",
        username: "username");
    await FirebaseFirestore.instance.collection('Stories').doc(uuid).set({
      'id': uuid,
      'userid': user.id,
      'views': [],
      'date': DateTime.now(),
      'username': user.username,
      'userimage': user.image,
      'imageurl': imageurl,
      'videourl': vidurl,
      'caption': controller.text ?? null
    });
    setState(() {
      isloading = false;
    });
    log('end');
    deleteAfter24(model: model);
    Navigator.pop(context);
  }
}
