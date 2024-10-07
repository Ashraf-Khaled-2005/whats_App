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
            ? AssetImage('images/splash_white.png')
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

Future<File?> PickImageGallery() async {
  var image = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (image != null) {
    return File(image.path);
  } else {
    return null;
  }
}

Future<String> Getimgaeurl(String uuid, File image, String child) async {
  final rref = FirebaseStorage.instance.ref().child(child).child(uuid + 'jpg');
  await rref.putFile(image!);
  final imageurl = await rref.getDownloadURL();
  return imageurl;
}
