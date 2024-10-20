import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Auth/data/model/RegUser.dart';
import 'package:our_whatsapp/Features/Auth/presentation/manager/cubit/SignUpCubit/SignupCubit.dart';
import 'package:our_whatsapp/Features/Auth/presentation/manager/cubit/SignUpCubit/signupCubitstates.dart';
import 'package:our_whatsapp/Features/Auth/presentation/view/login/custom_widget/custom_text_field.dart';
import 'package:our_whatsapp/Features/Auth/presentation/view/login/verification_page.dart';
import 'package:our_whatsapp/core/service/auth_state.dart';
import 'package:our_whatsapp/core/service/cacheHelper.dart';
import 'package:our_whatsapp/Features/Auth/presentation/view/login.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/helper/imagepick.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late TextEditingController countryNameController;
  late TextEditingController countryCodeController;
  late TextEditingController numberController;
  late TextEditingController Email;
  late TextEditingController Username;
  late TextEditingController pass;
  late String image;
  bool isSaved = false;
  File? imagefile;
  late GlobalKey<FormState> key;
  late AutovalidateMode autovalidateMode;

  showCountryCodePicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: ['EG'],
      countryListTheme: CountryListThemeData(
          bottomSheetHeight: 600,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flagSize: 22,
          borderRadius: BorderRadius.circular(20),
          textStyle: const TextStyle(color: Colors.grey),
          inputDecoration: const InputDecoration(
              labelStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(
                Icons.language,
                color: Color.fromARGB(255, 212, 194, 137),
              ),
              hintText: "Search country name or code",
              enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 120, 94, 94))),
              focusedBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 176, 137, 55))))),
      onSelect: (country) {
        countryNameController.text = country.name;
        countryCodeController.text = country.countryCode;
      },
    );
  }

  @override
  void initState() {
    Email = TextEditingController();
    Username = TextEditingController();
    countryNameController = TextEditingController(text: 'Egypt');
    countryCodeController = TextEditingController(text: '20');
    numberController = TextEditingController();
    key = GlobalKey();
    pass = TextEditingController();
    autovalidateMode = AutovalidateMode.disabled;
    super.initState();
  }

  @override
  void dispose() {
    countryNameController.dispose();
    countryCodeController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          "Enter your Personal Data",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffe9b336), Color(0xffe3bf4a)])),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: key,
              autovalidateMode: autovalidateMode,
              child: Column(
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Image.asset(
                          "images/whats_app_Signup.png",
                          height: 300,
                          width: 300,
                        ),
                        Positioned(
                          left: 146,
                          bottom: 128,
                          child: Container(
                            width: 120, // Adjust width according to your needs
                            height:
                                120.0, // Adjust height according to your needs
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors
                                    .white, // Set your desired border color here
                                width: 4.0, // Adjust the width of the border
                              ),
                            ),
                            child: CircleAvatar(
                              radius:
                                  70, // Set the radius to control the size of the circle
                              backgroundImage: imagefile != null
                                  ? FileImage(
                                      imagefile!) // Display chosen image if available
                                  : null, // Fallback to a default image if no image is selected
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 160,
                          left: 184,
                          child: IconButton(
                            onPressed: () async {
                              final uuid = const Uuid().v4();
                              imagefile = await pickImageGallery();
                              if (imagefile != null) {
                                image = await getImgaeUrl(
                                    uuid, imagefile!, 'UsersImages');
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffd95a00),
                      border: Border.all(width: 1),
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        CustomTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is required";
                            }
                          },
                          onSaved: (value) {},
                          controller: Username,
                          hintText: "Enter UserName",
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field is required";
                            }
                          },
                          onSaved: (value) {},
                          controller: pass,
                          hintText: "Enter Pass",
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          validator: (value) {
                            if (value!.isEmpty || !(value!.contains('@'))) {
                              return "Enter a valid Email";
                            }
                          },
                          onSaved: (value) {},
                          controller: Email,
                          hintText: "Email",
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 70,
                              child: CustomTextField(
                                validator: (value) {},
                                onSaved: (value) {},
                                onTap: showCountryCodePicker,
                                controller: countryCodeController,
                                prefixText: '+',
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field is required";
                                  }
                                },
                                onSaved: (value) {},
                                controller: numberController,
                                hintText: 'Phone number',
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: Checkbox.adaptive(
                                checkColor: Colors.white,
                                key: ValueKey<bool>(isSaved),
                                activeColor: const Color(0xFF00A884),
                                value: isSaved,
                                onChanged: (value) {
                                  setState(() {
                                    isSaved = value ?? false;
                                  });
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isSaved = !isSaved;
                                });
                              },
                              child: const Text(
                                "Saved",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        // Adding the "NEXT" button here
                        BlocConsumer<SignupCubit, Signupstates>(
                          listener: (context, state) {
                            if (state is SignupCubitsuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AuthStateHandler()),
                              );
                            } else if (state is SignupCubitFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.err)));
                            }
                          },
                          builder: (context, state) {
                            if (state is SignupCubitloading) {
                              return const CircularProgressIndicator(); // Show loading indicator
                            } else {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .green, // Customize the button color
                                ),
                                onPressed: () {
                                  if (key.currentState!.validate()) {
                                    if (imagefile != null) {
                                      ReguserModel user = ReguserModel(
                                        phone: countryCodeController.text +
                                            numberController.text,
                                        id: '0',
                                        email: Email.text,
                                        pass: pass.text,
                                        username: Username.text,
                                        imagefile: image,
                                        Chatsids: [],
                                      );
                                      context.read<SignupCubit>().signUp(user);

                                      if (isSaved) {
                                        CacheHelper.saveData(
                                            key: "ISSAVED", value: isSaved);
                                        CacheHelper.saveData(
                                            key: "EMAIL", value: Email.text);
                                        CacheHelper.saveData(
                                            key: "PASS", value: pass.text);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text("Image is required")),
                                      );
                                    }
                                  }
                                  setState(() {
                                    autovalidateMode = AutovalidateMode.always;
                                  });
                                },
                                child: const Text("NEXT"),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: const Text(
                        "Already Have an account?",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
