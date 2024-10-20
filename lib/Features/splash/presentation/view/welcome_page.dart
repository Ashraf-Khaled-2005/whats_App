import 'package:flutter/material.dart';
import 'package:our_whatsapp/Features/Auth/presentation/view/login/Signup.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xfffaa866), Color(0xffe3bf4a)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/wazzup_logo.png"),
            Column(
              children: [
                const Text(
                  "Welcome to Wazz up!!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:Colors.white),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          text: "Read our ",
                          style: TextStyle(color: Colors.white, height: 1.5),
                          children: [
                            TextSpan(
                                text: "Privacy Policy. ",
                                style: TextStyle(color: Colors.blue)),
                            TextSpan(
                                text:
                                    'Tap "Agree and continue" to accept the '),
                            TextSpan(
                                text: 'Terms of Services',
                                style: TextStyle(color: Colors.blue))
                          ])),
                ),
                SizedBox(
                  height: 42,
                  width: MediaQuery.of(context).size.width - 100,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfff6621b),
                          foregroundColor: const Color(0xffffffff),
                          splashFactory: NoSplash.splashFactory,
                          elevation: 0,
                          shadowColor: Colors.transparent),
                      child: const Text('AGREE AND CONTINUE')),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
