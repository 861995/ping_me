import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class HomeScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaveUserData extends HomeScreenEvent {
  final User user;

  SaveUserData(this.user);

  @override
  List<Object?> get props => [user];
}

class FetchUsersStream extends HomeScreenEvent {}

class UpdateUserStatus extends HomeScreenEvent {
  final String userId;
  final bool isOnline;

  UpdateUserStatus(this.userId, this.isOnline);

  @override
  List<Object?> get props => [userId, isOnline];
}

class FetchUserStatus extends HomeScreenEvent {
  final String userId;

  FetchUserStatus(this.userId);

  @override
  List<Object?> get props => [userId];
}
