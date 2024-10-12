import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? image;
  final String? curriamge;
  const ImagePickerWidget({
    super.key,
    this.image,
    this.curriamge,
  });

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return CircleAvatar(
        radius: 32,
        backgroundImage: curriamge == null
            ? const AssetImage('images/splash_white.png')
            : NetworkImage(curriamge!),
      );
    } else {
      return CircleAvatar(
        radius: 32,
        backgroundImage: FileImage(image!),
      );
    }
  }
}

Future<File?> pickImageGallery() async {
  var image = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (image != null) {
    return File(image.path);
  } else {
    return null;
  }
}

Future<File?> pickVideoGallery() async {
  var video = await ImagePicker().pickVideo(source: ImageSource.gallery);

  if (video != null) {
    return File(video.path);
  } else {
    return null;
  }
}

Future<String> getImgaeUrl(String uuid, File image, String child) async {
  final rref = FirebaseStorage.instance.ref().child(child).child('${uuid}jpg');
  await rref.putFile(image);
  final imageurl = await rref.getDownloadURL();
  return imageurl;
}

Future<void> openCamera() async {
  final XFile? image =
      await ImagePicker().pickImage(source: ImageSource.camera);
  if (image != null) {
    log('Image Path: ${image.path}');
  }
}
