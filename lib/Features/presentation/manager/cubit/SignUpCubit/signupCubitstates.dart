abstract class Signupstates {}

class SignupCubitFailure extends Signupstates {
  final String err;

  SignupCubitFailure({required this.err});
}

class SignupCubitsuccess extends Signupstates {}

class SignupCubitintial extends Signupstates {}

class SignupCubitloading extends Signupstates {}
