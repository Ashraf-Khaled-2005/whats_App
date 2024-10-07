import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:our_whatsapp/Features/Chats/domain/Repo/Chat_Repo.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final ChatRepo Repo;
  EditProfileCubit(this.Repo) : super(EditProfileInitial());

  void updateProfile(
      {required String username,
      required String phone,
      required String image}) {
    emit(EditProfileLoading());
    Repo.editProfile(username: username, phone: phone, image: image)
        .then((value) {
      value.fold((l) {
        emit(EditProfileError(message: l.message));
      }, (r) {
        emit(EditProfileSuccess());
      });
    });
  }
}
