import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Auth/presentation/view/login/Signup.dart';
import 'package:our_whatsapp/core/service/auth_state.dart';

import '../../../../core/service/cacheHelper.dart';
import '../manager/cubit/Login/login_cubit.dart';
import 'login/custom_widget/custom_text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController email;
  late TextEditingController pass;
  late GlobalKey<FormState> key;
  late AutovalidateMode mode;
  bool isSaved = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = TextEditingController();
    pass = TextEditingController();
    key = GlobalKey();
    mode = AutovalidateMode.disabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: mode,
          key: key,
          child: Column(
            children: [
              Container(
                  height: 200,
                  width: 400,
                  child: Image.asset("images/splash_white.png")),
              const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: CustomTextField(
                  controller: email,
                  onSaved: (value) {
                    email.text = value!;
                  },
                  hintText: "Email",
                  validator: (value) {
                    if (value!.isEmpty || !value!.contains("@"))
                      return "Invalid Email";
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: CustomTextField(
                  controller: pass,
                  onSaved: (value) {
                    pass.text = value!;
                  },
                  hintText: "Password",
                  validator: (value) {
                    if (value!.isEmpty) return "Invalid Password";
                  },
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 42,
                width: MediaQuery.of(context).size.width - 100,
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthStateHandler()));
                    }
                  },
                  builder: (context, state) {
                    if (state is LoginLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is LoginError) {
                      Center(
                        child: Text("Sorry Error=> ${state.err}"),
                      );
                    }
                    return ElevatedButton(
                        onPressed: () {
                          if (key.currentState!.validate()) {
                            key.currentState!.save();
                            context
                                .read<LoginCubit>()
                                .Login(email: email.text, pass: pass.text);
                            if (isSaved) {
                              CacheHelper.saveData(
                                  key: "ISSAVED", value: isSaved);
                              CacheHelper.saveData(
                                  key: "EMAIL", value: email.text);
                              CacheHelper.saveData(
                                  key: "PASS", value: pass.text);
                            }
                          } else {
                            setState(() {
                              mode = AutovalidateMode.always;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A884),
                            foregroundColor: const Color(0xFF111b21),
                            splashFactory: NoSplash.splashFactory,
                            elevation: 0,
                            shadowColor: Colors.transparent),
                        child: const Text('Login'));
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: "Don't have account? ",
                    style: TextStyle(color: Color(0xFF8696A0), height: 1.5),
                    children: [
                      TextSpan(
                          text: "Sign up. ",
                          style: TextStyle(color: Color(0xFF53BDEB))),
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text("Don't Have an account?")),
            ],
          ),
        ),
      ),
    );
  }
}
