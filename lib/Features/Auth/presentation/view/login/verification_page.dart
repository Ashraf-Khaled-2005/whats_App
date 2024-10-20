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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: InkWell(
            onTap: () {
              log(auth.currentUser!.emailVerified.toString());
            },
            child: const Text("Verify Your Email please to Continue")),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RichText(
              textAlign: TextAlign.center,
              // ignore: prefer_const_constructors
              text: TextSpan(
                style: const TextStyle(color: Colors.grey, height: 1.5),
                children: const [
                  // TextSpan(
                  //   text:
                  //       "You've tried to register +${widget.phone}. before requesting an SMS or Call with your code.",
                  // ),
                  TextSpan(
                    text: " Wrong number?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              log("email end");
              await auth.currentUser!.sendEmailVerification();
            },
            child: const Row(
              children: [
                Icon(Icons.message, color: Colors.grey),
                SizedBox(width: 10),
                Text("Resend SMS", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
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
                    SnackBar(content: Text("Please Vertify the email")));
              }
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }
}
