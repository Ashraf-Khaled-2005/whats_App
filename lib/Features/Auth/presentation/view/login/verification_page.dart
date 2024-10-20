import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our_whatsapp/core/service/auth_state.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    auth.currentUser!.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffca8e0c),
        elevation: 0,
        title: InkWell(
            onTap: () {
              // log(auth.currentUser!.emailVerified.toString());
            },
            child: const Text(
              "Verify Your Email",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xfffaa866), Color(0xffe3bf4a)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/verification_wazzup.png"),
            RichText(
              textAlign: TextAlign.center,
              // ignore: prefer_const_constructors
              text: TextSpan(
                style: const TextStyle(color: Colors.white, height: 1.5),
                children: const [
                  // TextSpan(
                  //   text:
                  //       "You've tried to register +${widget.phone}. before requesting an SMS or Call with your code.",
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                log("email end");
                await auth.currentUser!.sendEmailVerification();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xffd95a00),
                ),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                padding: EdgeInsets.all(15),
                child: const Row(
                  children: [
                    Icon(Icons.message, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Resend SMS", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  await auth.currentUser!.reload();
                  if (auth.currentUser!.emailVerified) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuthStateHandler(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please Vertify the Email")));
                  }
                },
                child:
                    const Text("Verify", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
