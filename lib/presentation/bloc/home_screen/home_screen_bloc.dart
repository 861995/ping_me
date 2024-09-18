import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeScreenBloc() : super(UserInitial()) {
    on<SaveUserData>(_onSaveUserData);
    on<FetchUsersStream>(_onFetchUsersStream);
  }

  void _onSaveUserData(
      SaveUserData event, Emitter<HomeScreenState> emit) async {
    emit(UserLoading());
    try {
      await _firestore.collection('users').doc(event.user.uid).set({
        'uid': event.user.uid,
        'email': event.user.email,
        'displayName': event.user.displayName,
        'photoURL': event.user.photoURL,
      });
      emit(UserSaved());
    } catch (e) {
      emit(UserFailure('Failed to save user data'));
    }
  }

  Future<void> _onFetchUsersStream(
      FetchUsersStream event, Emitter<HomeScreenState> emit) async {
    final firestore = FirebaseFirestore.instance;
    final userCollection = firestore.collection('users');

    emit(UserLoading());

    await emit.forEach(
      userCollection.snapshots(),
      onData: (QuerySnapshot snapshot) {
        final users = snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();

        if (users.isNotEmpty) {
          return UsersLoaded(users);
        } else {
          return NoUsersFound();
        }
      },
      onError: (_, __) => NoUsersFound(),
    );
  }
}
