import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? image;
  const ImagePickerWidget({
    super.key,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const CircleAvatar(
        radius: 32,
        backgroundImage: AssetImage('images/splash_white.png'),
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
