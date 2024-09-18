import 'package:equatable/equatable.dart';

abstract class HomeScreenState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends HomeScreenState {}

class UserLoading extends HomeScreenState {}

class UserSaved extends HomeScreenState {}

class UsersLoaded extends HomeScreenState {
  final List<Map<String, dynamic>> users;

  UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserFailure extends HomeScreenState {
  final String message;

  UserFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class NoUsersFound extends HomeScreenState {}
