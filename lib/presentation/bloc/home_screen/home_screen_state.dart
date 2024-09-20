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

// New state for user status
class UserStatusUpdated extends HomeScreenState {
  final String userId;
  final bool isOnline;

  UserStatusUpdated(this.userId, this.isOnline);

  @override
  List<Object?> get props => [userId, isOnline];
}

class UserStatusLoaded extends HomeScreenState {
  final String userId;
  final bool isOnline;
  final DateTime lastSeen;

  UserStatusLoaded(this.userId, this.isOnline, this.lastSeen);

  @override
  List<Object?> get props => [userId, isOnline];
}

class UserStatusError extends HomeScreenState {
  final String message;

  UserStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
