import 'package:flutter/material.dart';
import 'package:our_whatsapp/login/custom_widget/custom_text_field.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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

      body: Column(
children: [

  Container(
    height: 200,
    width: 400,
    child: Image.asset("images/whatsapp_word.png")),
SizedBox(),  
Padding(

  padding: const EdgeInsets.symmetric(horizontal: 50),
  child: CustomTextField(
               hintText: "Email",
              ),
),
SizedBox(height: 40,),

Padding(

  padding: const EdgeInsets.symmetric(horizontal: 50),
  child: CustomTextField(
               hintText: "Password",
              ),
),
SizedBox(height: 100,),

SizedBox(
                  height: 42,
                  width: MediaQuery.of(context).size.width - 100,
                  child: ElevatedButton(onPressed: (){


                  },style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00A884),
                  foregroundColor: Color(0xFF111b21),
                  splashFactory: NoSplash.splashFactory,
                  elevation: 0,
                  shadowColor: Colors.transparent
                  
                  
                  ), child: const Text('Login')),
                ),
                  Padding(
                  padding: const EdgeInsets.symmetric(horizontal:30,vertical: 20 ),
                  child: RichText(
                    textAlign: TextAlign.center,
                      text: const TextSpan(text: "Don't have account? ",style: TextStyle(
                  color: Color(0xFF8696A0)
                  ,height: 1.5
                  
                  
                      ), children: [
                    TextSpan(text: "Sign up. ",style: TextStyle(
                      color: Color(0xFF53BDEB)
                    )),])))


],


      ),

    );
  }
}