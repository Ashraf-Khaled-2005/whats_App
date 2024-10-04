abstract class SharedState {}

class SharedInitial extends SharedState {}

class SharedSuccess extends SharedState {
  final bool value;
  final String pass, email;

  SharedSuccess({required this.value, required this.pass, required this.email});
}