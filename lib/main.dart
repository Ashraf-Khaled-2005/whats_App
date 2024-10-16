import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/core/util/service_loc.dart';
import 'Features/Auth/data/auth_Repo/authRepo.dart';
import 'Features/Auth/presentation/manager/cubit/Login/login_cubit.dart';
import 'Features/Auth/presentation/manager/cubit/Shared_bloc/Shared_cubit.dart';
import 'Features/Auth/presentation/manager/cubit/Shared_bloc/Shared_cubit_state.dart';
import 'Features/Auth/presentation/manager/cubit/SignUpCubit/SignupCubit.dart';
import 'Features/Chats/data/Repo/Chat_Repo.dart';
import 'Features/Chats/presentation/manager/GetUserDataCubit/get_user_data_cubit.dart';
import 'Features/Chats/presentation/manager/cubit/edit_profile_cubit.dart';
import 'Features/splash/presentation/view/welcome_page.dart';
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
  ServiceLoc.init();
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
            getIt<AuthrepoImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) => LoginCubit(
            getIt<AuthrepoImpl>(),
          ),
        ),
        BlocProvider(create: (_) => SharedCubit()..getShared()),
        BlocProvider(
          create: (_) => GetUserDataCubit(
            getIt<ChatRepoImpl>(),
          ),
        ),
        BlocProvider(
          create: (_) => EditProfileCubit(
            getIt<ChatRepoImpl>(),
          ),
        )
      ],
      child: Builder(
        builder: (context) {
          return BlocConsumer<SharedCubit, SharedState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is SharedSuccess && state.value == true) {
                if (FirebaseAuth.instance.currentUser != null) {
                  return MaterialApp(
                    themeAnimationDuration: const Duration(milliseconds: 700),
                    theme: state.theme! ? ThemeData.light() : ThemeData.dark(),
                    debugShowCheckedModeBanner: false,
                    home: const AuthStateHandler(),
                  );
                } else {
                  context
                      .read<LoginCubit>()
                      .Login(email: state.email, pass: state.pass);
                }

                return MaterialApp(
                  themeAnimationDuration: const Duration(milliseconds: 700),
                  theme: state.theme! ? ThemeData.light() : ThemeData.dark(),
                  debugShowCheckedModeBanner: false,
                  home: const AuthStateHandler(),
                );
              }

              return MaterialApp(
                themeAnimationDuration: const Duration(seconds: 1),
                theme: context.read<SharedCubit>().islight
                    ? ThemeData.light()
                    : ThemeData.dark(),
                debugShowCheckedModeBanner: false,
                home: const WelcomePage(),
              );
            },
          );
        },
      ),
    );
  }
}
