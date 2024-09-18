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
