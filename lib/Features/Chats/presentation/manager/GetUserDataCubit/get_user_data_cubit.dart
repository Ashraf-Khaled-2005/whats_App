import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:our_whatsapp/Features/Chats/data/model/userData.dart';
import 'package:our_whatsapp/Features/Chats/domain/Repo/Chat_Repo.dart';

part 'get_user_data_state.dart';

class GetUserDataCubit extends Cubit<GetUserDataState> {
  final ChatRepo Repo;
  late MyUserData userData;
  GetUserDataCubit(this.Repo) : super(GetUserDataInitial());

  void getData() async {
    var result = await Repo.getData();

    result.fold((l) {
      emit(GetUserDatafailure(err: l.message));
    }, (r) {
      userData = r;
      emit(GetUserDatasuccess(user: userData));
    });
  }
}
