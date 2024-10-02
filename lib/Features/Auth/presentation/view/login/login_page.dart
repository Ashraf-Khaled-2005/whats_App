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
import 'package:uuid/uuid.dart';

import '../../../../../core/service/imagepick.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController countryNameController;
  late TextEditingController countryCodeController;
  late TextEditingController numberController;
  late TextEditingController Email;
  late TextEditingController Username;
  late TextEditingController pass;
  late String image;
  bool isSaved = false;
  File? imagefile = null;
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: key,
            autovalidateMode: autovalidateMode,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'WhatsApp will need to verify your number. ',
                      style: TextStyle(color: Colors.grey, height: 1.5),
                      children: [
                        TextSpan(
                            text: "What's my number",
                            style: TextStyle(color: Colors.blue))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    ImagePickerWidget(
                      image: imagefile,
                    ),
                    Positioned(
                      bottom: -20,
                      right: -20,
                      child: IconButton(
                          onPressed: () async {
                            final uuid = const Uuid().v4();
                            imagefile = await PickImageGallery();
                            image = await Getimgaeurl(
                                uuid, imagefile!, 'UsersImages');
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 24,
                          )),
                    )
                  ],
                ),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Field iS requried";
                    }
                  },
                  onSaved: (value) {},
                  controller: Username,
                  hintText: "Enter UserName",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Field iS requried";
                    }
                  },
                  onSaved: (value) {},
                  controller: pass,
                  hintText: "Enter Pass",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  validator: (value) {
                    if (value!.isEmpty || !(value!.contains('@'))) {
                      return "Enter a vaild Email";
                    }
                  },
                  onSaved: (value) {},
                  controller: Email,
                  hintText: "Email",
                ),
                const SizedBox(
                  height: 10,
                ),
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
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: CustomTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field iS requried";
                        }
                      },
                      onSaved: (value) {},
                      controller: numberController,
                      hintText: 'phone number',
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.number,
                    ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Checkbox.adaptive(
                          checkColor: Colors.white,
                          key: ValueKey<bool>(
                              isSaved), // Unique key for animation
                          activeColor: const Color(0xFF00A884),
                          value: isSaved,
                          onChanged: (value) {
                            setState(() {
                              isSaved = value ?? false;
                            });
                          },
                        )),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSaved = !isSaved;
                        });
                      },
                      child: Text(
                        "Saved",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: BlocConsumer<SignupCubit, Signupstates>(
        listener: (context, state) {
          if (state is SignupCubitsuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthStateHandler()),
            );
          } else if (state is SignupCubitFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.err)));
          }
        },
        builder: (context, state) {
          if (state is SignupCubitloading)
            return CircularProgressIndicator();
          else {
            return TextButton(
                onPressed: () {
                  if (key.currentState!.validate()) {
                    if (imagefile != null) {
                      ReguserModel user = ReguserModel(
                          id: '0',
                          email: Email.text,
                          pass: pass.text,
                          username: Username.text,
                          imagefile: image);
                      context.read<SignupCubit>().signUp(user);
                      if (isSaved) {
                        CacheHelper.saveData(key: "ISSAVED", value: isSaved);
                        CacheHelper.saveData(key: "EMAIL", value: Email.text);
                        CacheHelper.saveData(key: "PASS", value: pass.text);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Image is requried")));
                    }
                  }
                  setState(() {
                    autovalidateMode = AutovalidateMode.always;
                  });
                },
                child: const Text("NEXT"));
          }
        },
      ),
    );
  }
}
