import 'package:get_it/get_it.dart';
import 'package:our_whatsapp/Features/Auth/data/auth_Repo/authRepo.dart';
import 'package:our_whatsapp/Features/Chats/data/Repo/Chat_Repo.dart';

final getIt = GetIt.instance;

class ServiceLoc {
  static void init() {
    getIt.registerSingleton<ChatRepoImpl>(ChatRepoImpl());

    getIt.registerSingleton<AuthrepoImpl>(AuthrepoImpl());
  }
}
