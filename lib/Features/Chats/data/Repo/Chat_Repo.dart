import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';
import '../../../Auth/domain/auth_Repo/Auth_Repo.dart';
import '../../domain/Repo/Chat_Repo.dart';

class ChatRepoImpl extends ChatRepo {
  @override
  Future<Either<MyExcepation, UserData>> getData() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (result.exists) {
        Map<String, dynamic> map = result.data()!;
        var userData = UserData(
            image: map['image'],
            username: map['username'],
            email: map['email'],
            phone: map['phone']);
        return Right(userData);
      } else {
        return Left(MyExcepation(message: 'User not found'));
      }
    } catch (e) {
      return Left(MyExcepation(message: e.toString()));
    }
  }
}
