part of 'get_user_data_cubit.dart';

@immutable
sealed class GetUserDataState {}

final class GetUserDataInitial extends GetUserDataState {}

final class GetUserDataloading extends GetUserDataState {}

final class GetUserDatafailure extends GetUserDataState {
  final String err;

  GetUserDatafailure({required this.err});
}

final class GetUserDatasuccess extends GetUserDataState {
  final UserData user;

  GetUserDatasuccess({required this.user});
}
