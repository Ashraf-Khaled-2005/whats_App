import 'package:dartz/dartz.dart';
import 'package:our_whatsapp/Features/Auth/domain/auth_Repo/Auth_Repo.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';

abstract class ChatRepo {
  Future<Either<MyExcepation, UserData>> getData();
}