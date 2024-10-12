import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:our_whatsapp/Features/Auth/data/model/RegUser.dart';

import '../../domain/auth_Repo/Auth_Repo.dart';

class AuthrepoImpl extends AuthRepo {
  @override
  Future<Either<MyExcepation, void>> SignUp(ReguserModel user) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.pass,
      );
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(
            MyExcepation(message: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return left(
            MyExcepation(message: 'The account already exists for that email'));
      } else {
        return left(
          MyExcepation(
            message: e.toString(),
          ),
        );
      }
    } catch (e) {
      return left(MyExcepation(message: e.toString()));
    }
  }

  @override
  Future<Either<MyExcepation, void>> Login(
      {required String email, required String pass}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return left(MyExcepation(message: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        return left(
            MyExcepation(message: 'Wrong password provided for that user.'));
      } else {
        log(e.toString());
        return left(MyExcepation(message: e.toString()));
      }
    }
  }
}
