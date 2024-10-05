import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Auth/data/auth_Repo/authRepo.dart';
import 'package:our_whatsapp/Features/Auth/presentation/manager/cubit/Login/login_cubit.dart';
import 'package:our_whatsapp/Features/Auth/presentation/manager/cubit/Shared_bloc/Shared_cubit.dart';
import 'package:our_whatsapp/Features/Auth/presentation/manager/cubit/SignUpCubit/SignupCubit.dart';
import 'package:our_whatsapp/Features/Auth/presentation/view/login/Signup.dart';
import 'package:our_whatsapp/Features/Chats/data/Repo/Chat_Repo.dart';
import 'package:our_whatsapp/Features/Chats/presentation/manager/cubit/get_user_data_cubit.dart';
import 'package:our_whatsapp/Features/splash/presentation/view/welcome_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Features/Auth/presentation/manager/cubit/Shared_bloc/Shared_cubit_state.dart';
import 'core/service/auth_state.dart';
import 'core/service/bloc_ob.dart';
import 'core/service/cacheHelper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  await CacheHelper.initCacheHelper();
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
        BlocProvider(
          create: (context) => LoginCubit(
            AuthrepoImpl(),
          ),
        ),
        BlocProvider(create: (_) => SharedCubit()..getShared()),
        BlocProvider(create: (_) => GetUserDataCubit(ChatRepoImpl()))
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'our Whatsapp',
            theme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            home: BlocConsumer<SharedCubit, SharedState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is SharedSuccess && state.value == true) {
                  context
                      .read<LoginCubit>()
                      .Login(email: state.email, pass: state.pass);
                  return const AuthStateHandler(); // Temporary empty widget, as listener will handle navigation
                }
                return const WelcomePage();
              },
            ),
          );
        },
      ),
    );
  }
}
