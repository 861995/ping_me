import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInWithEmail extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmail({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignInWithGoogle extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SignOut extends AuthEvent {
  @override
  List<Object> get props => [];
}
