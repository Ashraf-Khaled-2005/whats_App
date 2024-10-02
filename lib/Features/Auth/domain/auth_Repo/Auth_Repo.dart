import 'package:dartz/dartz.dart';
import 'package:our_whatsapp/Features/Auth/data/model/RegUser.dart';

abstract class AuthRepo {
  Future<Either<MyExcepation, void>> SignUp(ReguserModel user);
}

class MyExcepation implements Exception {
  final String message;

  MyExcepation({required this.message});
}
