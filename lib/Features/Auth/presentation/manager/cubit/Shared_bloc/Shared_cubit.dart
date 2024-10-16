import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/service/cacheHelper.dart';
import 'Shared_cubit_state.dart';

class SharedCubit extends Cubit<SharedState> {
  late bool value;
  late String email;
  late bool islight;
  late String pass;
  SharedCubit() : super(SharedInitial());

  void getShared() {
    value = CacheHelper.getbool(key: 'ISSAVED');
    email = CacheHelper.getString(key: 'EMAIL');
    pass = CacheHelper.getString(key: 'PASS');
    islight = CacheHelper.getbool(key: 'islight');
    emit(SharedSuccess(value: value, pass: pass, email: email, theme: islight));
  }
}
