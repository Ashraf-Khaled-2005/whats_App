import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:our_whatsapp/login/custom_widget/custom_text_field.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {

  late TextEditingController codeController;
  @override
  void initState() {
    codeController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
appBar: AppBar(
backgroundColor: Theme.of(context).scaffoldBackgroundColor,
elevation: 0,
title: Text("verify your number"),
centerTitle: true,
),
body: SingleChildScrollView(

padding: EdgeInsets.symmetric(horizontal: 20),
child: Column(
children: [

  Padding(padding: EdgeInsets.symmetric(horizontal: 10),
  
  child: RichText(
    
    textAlign: TextAlign.center,
    text: TextSpan(
style: TextStyle(
  color: Colors.grey,
 height: 1.5 
),
children: [

  TextSpan(
    text:"You've tried to register +201024769311. before requesting an SMS or Call with your code.",

  ),
  TextSpan(
text: " Wrong number?",
style: TextStyle(color: Colors.blue)
  ) 
]


  )),
  ),

  const SizedBox(height: 20,),
  Container(
    padding: EdgeInsets.symmetric(horizontal: 80),
    child: CustomTextField(
      controller: codeController,
hintText: "- - -  - - -",
fontSize: 30,
autoFocus: true,
keyboardType: TextInputType.number,
onChanged: (value){},


    ),
  ),
  const SizedBox(height: 20,),

  Text("Enter 6-digit code",style: TextStyle(color: Colors.grey),),

    const SizedBox(height: 30,),
    Row(children: [
Icon(Icons.message,color: Colors.grey,),
const SizedBox(height: 20,),
Text("Resend SMS",style: TextStyle(color: Colors.grey),),
const SizedBox(height: 10,),


      
    ],)

],


),


),


    );
  }
}