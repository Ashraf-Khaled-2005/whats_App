import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/GetUserDataCubit/get_user_data_cubit.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:our_whatsapp/core/service/auth_state.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/helper/imagepick.dart';
import '../../../../../core/service/cacheHelper.dart';
import '../../../../Auth/presentation/manager/cubit/Shared_bloc/Shared_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final MyUserData user;

  const ProfileScreen({super.key, required this.user});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool islight = false;
  late TextEditingController _nameController;

  late TextEditingController _phoneController;
  File? image;
  String? imagepath;
  initState() {
    super.initState();
    islight = context.read<SharedCubit>().islight;

    _nameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Color(0xfff1892e),
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
                      var uuid = const Uuid().v4();
                      image = await pickImageGallery();
                      if (image == null) {}
                      imagepath =
                          await getImgaeUrl(uuid, image!, 'UsersImages');
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
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: widget.user.phone,
                prefixIcon: const Icon(Icons.phone),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
                title: const Text("Light"),
                value: islight,
                onChanged: (value) async {
                  await CacheHelper.saveData(key: 'islight', value: !islight);
                  islight = !islight;
                  context.read<SharedCubit>().getShared();
                  setState(() {});
                }),
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
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
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
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthStateHandler()),
                          (Route<dynamic> route) =>
                              false, // This will remove all previous routes
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                      ),
                      child: const Text('Logout'),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
