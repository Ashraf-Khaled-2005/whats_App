import 'package:flutter/material.dart';
import 'package:our_whatsapp/Features/splash/presentation/view/welcome_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'our Whatsapp',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: const WelcomePage());
  }
}
