import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';

class ProfileScreen extends StatefulWidget {
  final UserData user;

  const ProfileScreen({super.key, required this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _aboutController;

  late TextEditingController _phoneController;

  final ImagePicker _picker = ImagePicker();
  String _imageUrl =
      'https://th.bing.com/th/id/OIP.5pGmMOmWdCOwrIy_WTIyXQHaJQ?rs=1&pid=ImgDetMain';

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageUrl = image.path;
      });
    }
  }

  initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
    _aboutController = TextEditingController(text: "About");
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundImage: _imageUrl.startsWith('http')
                      ? NetworkImage(_imageUrl)
                      : FileImage(File(_imageUrl)) as ImageProvider,
                  radius: 60,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _aboutController,
              decoration: const InputDecoration(
                labelText: 'About',
                prefixIcon: Icon(Icons.info),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle save or submit action
                print('Name: ${_nameController.text}');
                print('About: ${_aboutController.text}');
                print('Phone: ${_phoneController.text}');
              },
              child: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
