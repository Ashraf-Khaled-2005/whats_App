import 'package:flutter/material.dart';
import 'package:our_whatsapp/Features/Auth/view/login/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Image.asset("images/Square.png"),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
              child: Column(
            children: [
              const Text(
                "Welcome to WhatsApp",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                        text: "Read our",
                        style: TextStyle(color: Color(0xFF8696A0), height: 1.5),
                        children: [
                          TextSpan(
                              text: "Privacy Policy. ",
                              style: TextStyle(color: Color(0xFF53BDEB))),
                          TextSpan(
                              text: 'Tap "Agree and continue" to accept the '),
                          TextSpan(
                              text: 'Terms of Services',
                              style: TextStyle(color: Color(0xFF53BDEB)))
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
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A884),
                        foregroundColor: const Color(0xFF111b21),
                        splashFactory: NoSplash.splashFactory,
                        elevation: 0,
                        shadowColor: Colors.transparent),
                    child: const Text('AGREE AND CONTINUE')),
              )
            ],
          ))
        ],
      ),
    );
  }
}
