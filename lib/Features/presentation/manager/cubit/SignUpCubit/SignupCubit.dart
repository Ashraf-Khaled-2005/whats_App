import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_whatsapp/Features/Auth/data/model/RegUser.dart';
import 'package:our_whatsapp/Features/Auth/domain/auth_Repo/Auth_Repo.dart';

import 'signupCubitstates.dart';

class SignupCubit extends Cubit<Signupstates> {
  final AuthRepo Repo;
  SignupCubit(this.Repo) : super(SignupCubitintial());

  void signUp(ReguserModel user) async {
    emit(SignupCubitloading());
    var result = await Repo.SignUp(user);

    result.fold((l) {
      return SignupCubitFailure(err: l.message);
    }, (r) async {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'email': user.email,
        'pass': user.pass,
        'image': user.imagefile,
        'username': user.username,
        'id': FirebaseAuth.instance.currentUser!.uid
      });
      SignupCubitsuccess();
    });
  }
}
