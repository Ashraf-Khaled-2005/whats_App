import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Auth/presentation/view/login/custom_widget/custom_text_field.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/GetUserDataCubit/get_user_data_cubit.dart';
import 'package:our_whatsapp/Features/statue/data/model/statusModel.dart';
import 'package:our_whatsapp/core/helper/imagepick.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import 'Show_my_stories.dart';

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
      resizeToAvoidBottomInset:
          false, // Prevent layout changes on keyboard open
      floatingActionButton: isloading
          ? CircularProgressIndicator()
          : FloatingActionButton(
              onPressed: _sendStory,
              child: const Icon(Icons.send),
            ),
      appBar: AppBar(
        backgroundColor: Color(0xfff1892e),
        title: const Text("Add Story"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/add_stories2.png"),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  colors: [
                    Color(0xffe9b336),
                    Color(0xffe3bf4a),
                  ],
                ),
              ),
            ),
            // Scrollable content
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: 210,
                        left: 70,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white10,
                          ),
                          width: 235,
                          height: 280,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(80, 120, 70, 0),
                        child: TextFormField(
                          controller: controller,
                          validator: (value) {
                            // Add your validation logic here
                            if (value == null || value.isEmpty) {
                              return 'Please enter a caption';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            hintText: "Caption",
                            hintStyle: TextStyle(
                                fontSize: 20), // Adds margin inside the field
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 20), // Sets font size for entered text
                          maxLines: null, // Allows the text to expand
                          minLines: 1, // Starts with one line
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(70, 270, 55, 0),
                        child: Center(
                          // Center the content
                          child: image != null // Check if image is available
                              ? Image.file(
                                  image!, // Display the image file
                                  height: h *
                                      .2, // Set height to 20% of screen height
                                  fit: BoxFit.cover, // Maintain aspect ratio
                                )
                              : video != null // Check if video is available
                                  ? SizedBox(
                                      height: h *
                                          .2, // Set height to 20% of screen height
                                      width:
                                          w, // Set width to the full width of the container
                                      child: VideoPlayer(
                                          videocontroller!), // Display video player
                                    )
                                  : SizedBox(
                                      height:
                                          h * .3, // Create an empty SizedBox
                                    ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(160, 500, 0, 0),
                        child: PopupMenuButton(
                          icon: Icon(
                            Icons.upload,
                            size: 50, // Increase the size of the icon
                            color: Colors
                                .white, // Change the color to make it stand out
                          ),
                          onSelected: (value) async {
                            if (value == 'Image') {
                              if (videocontroller != null) {
                                await videocontroller!.pause();
                              }
                              image = await pickImageGallery();
                              setState(() {});
                            }
                            if (value == 'Video') {
                              video = await pickVideoGallery();
                              if (video != null) {
                                videocontroller =
                                    VideoPlayerController.file(video!);
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
