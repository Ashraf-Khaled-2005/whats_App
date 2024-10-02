import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Auth/data/auth_Repo/authRepo.dart';
import 'package:our_whatsapp/Features/presentation/manager/cubit/SignUpCubit/SignupCubit.dart';
import 'package:our_whatsapp/Features/splash/presentation/view/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Features/presentation/view/login/verification_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SignupCubit(
              AuthrepoImpl(),
            ),
          ),
        ],
        child: MaterialApp(
            title: 'our Whatsapp',
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: const WelcomePage()));
  }
}
