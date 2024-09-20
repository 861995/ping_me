import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeScreenBloc() : super(UserInitial()) {
    on<SaveUserData>(_onSaveUserData);
    on<FetchUsersStream>(_onFetchUsersStream);
    on<UpdateUserStatus>(_onUpdateUserStatus);
    on<FetchUserStatus>(_onFetchUserStatus);
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
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    emit(UserLoading());

    try {
      // Fetch the conversations for the current user
      final conversationsSnapshot = await userCollection
          .doc(currentUserId)
          .collection('conversations')
          .get();

      // Create a map of userId to lastMessageTime
      Map<String, Timestamp?> lastMessageMap = {};
      for (var doc in conversationsSnapshot.docs) {
        lastMessageMap[doc.id] = doc.data()['lastMessageTime'] as Timestamp?;
      }

      await emit.forEach(
        userCollection.snapshots(),
        onData: (QuerySnapshot snapshot) {
          final users = snapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();

          if (users.isNotEmpty) {
            // Filter out the current user
            List<Map<String, dynamic>> _filteredUsers = users.where((user) {
              return user['uid'] != currentUserId;
            }).toList();

            // Attach lastMessageTime from conversations to users
            _filteredUsers.forEach((user) {
              user['lastMessageTime'] = lastMessageMap[user['uid']] ?? null;
            });

            // Sort the users based on lastMessageTime
            _filteredUsers.sort((a, b) {
              Timestamp? timeA = a['lastMessageTime'];
              Timestamp? timeB = b['lastMessageTime'];
              if (timeA == null && timeB == null) return 0;
              if (timeA == null) return 1;
              if (timeB == null) return -1;
              return timeB.compareTo(timeA);
            });

            return UsersLoaded(_filteredUsers);
          } else {
            return NoUsersFound();
          }
        },
        onError: (_, __) => NoUsersFound(),
      );
    } catch (e) {
      emit(NoUsersFound());
    }
  }

  Future<void> _onUpdateUserStatus(
      UpdateUserStatus event, Emitter<HomeScreenState> emit) async {
    try {
      await _firestore.collection('users').doc(event.userId).update({
        'isOnline': event.isOnline,
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(UserFailure('Failed to update user status'));
    }
  }

  void _onFetchUserStatus(
      FetchUserStatus event, Emitter<HomeScreenState> emit) async {
    await emit.forEach(
      _firestore.collection('users').doc(event.userId).snapshots(),
      onData: (statusSnapshot) {
        final isOnline = statusSnapshot['isOnline'] ?? false;
        final lastSeen = statusSnapshot['lastActive']?.toDate()
            as DateTime; // Ensure you convert it if it's a Timestamp
        return UserStatusLoaded(event.userId, isOnline, lastSeen);
      },
      onError: (_, __) => UserStatusError("Error"),
    );
  }
}
