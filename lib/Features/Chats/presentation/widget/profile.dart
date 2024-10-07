import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/GetUserDataCubit/get_user_data_cubit.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/service/imagepick.dart';

class ProfileScreen extends StatefulWidget {
  final UserData user;

  const ProfileScreen({super.key, required this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;

  late TextEditingController _phoneController;
  File? image;
  String? imagepath;
  initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
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
                ImagePickerWidget(
                  curriamge: imagepath ?? widget.user.image,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      var uuid = Uuid().v4();
                      image = await PickImageGallery();
                      if (image == null) {}
                      imagepath =
                          await Getimgaeurl(uuid, image!, 'UsersImages');
                      setState(() {});
                    },
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
              decoration: InputDecoration(
                labelText: widget.user.username,
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: widget.user.phone,
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            BlocConsumer<EditProfileCubit, EditProfileState>(
              listener: (context, state) {
                if (state is EditProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                } else if (state is EditProfileSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Edit Successed"),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is EditProfileLoading) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    context.read<EditProfileCubit>().updateProfile(
                        username: _nameController.text.isEmpty
                            ? widget.user.username
                            : _nameController.text,
                        phone: _phoneController.text.isEmpty
                            ? widget.user.phone
                            : _phoneController.text,
                        image: imagepath ?? widget.user.image);
                    context.read<GetUserDataCubit>().getData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Save'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
