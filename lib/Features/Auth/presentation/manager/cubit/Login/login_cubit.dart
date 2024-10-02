import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../domain/auth_Repo/Auth_Repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo Repo;
  LoginCubit(this.Repo) : super(LoginInitial());

  void Login({required String email, required String pass}) async {
    var result = await Repo.Login(email: email, pass: pass);

    result.fold((l) {
      emit(LoginError(err: l.message));
    }, (r) {
      emit(LoginSuccess());
    });
  }
}
