import 'package:flutter/material.dart';

class Addstory extends StatelessWidget {
   Addstory({super.key});
   TextEditingController? tex =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.close),
            ),
           
          ],
        ),
      ),
    );
  }
}
