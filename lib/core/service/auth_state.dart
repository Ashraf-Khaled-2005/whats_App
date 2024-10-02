import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our_whatsapp/Features/Chats/presentation/view/chats.dart';
import 'package:our_whatsapp/Features/presentation/view/login/login_page.dart';
import 'package:our_whatsapp/Features/presentation/view/login/verification_page.dart';

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong!'));
        } else if (snapshot.hasData && snapshot.data != null) {
          User user = snapshot.data!;
          if (!user.emailVerified) {
            return const VerificationPage();
          }

          return ChatScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
