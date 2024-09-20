import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatScreenBloc extends Bloc<ChatEvent, ChatState> {
  ChatScreenBloc() : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<FetchMessagesStreamEvent>(_onFetchMessagesStream);
    on<MessagesFetched>(_onMessagesFetched);
  }

  // Method to check if chat exists, and create if not
  Future<void> _createChatIfNotExists(String chatId, String receiverId) async {
    final chatDoc = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final chatSnapshot = await chatDoc.get();
    if (!chatSnapshot.exists) {
      await chatDoc.set({
        'users': [FirebaseAuth.instance.currentUser!.uid, receiverId],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Handler for sending messages
  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());

      // Ensure chat exists before sending the message
      await _createChatIfNotExists(event.chatId, event.receiverId);

      final chatDoc =
          FirebaseFirestore.instance.collection('chats').doc(event.chatId);

      // Add the message to the messages sub-collection
      await chatDoc.collection('messages').add({
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'message': event.message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update lastMessageTime for the current user
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      await usersCollection
          .doc(currentUserId)
          .collection('conversations')
          .doc(event.receiverId)
          .set({
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update lastMessageTime for the receiver
      await usersCollection
          .doc(event.receiverId)
          .collection('conversations')
          .doc(currentUserId)
          .set({
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update last message in chat document
      await chatDoc.update({
        'lastMessage': event.message,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      // Also update the lastMessageTime field directly in the users collection
      // await usersCollection.doc(currentUserId).update({
      //   'lastMessageTime': FieldValue.serverTimestamp(),
      // });
      // await usersCollection.doc(event.receiverId).update({
      //   'lastMessageTime': FieldValue.serverTimestamp(),
      // });

      emit(ChatInitial());
    } catch (e) {
      emit(NoChatFound('Error sending message: $e'));
    }
  }

  // Handler for fetching messages stream
  Future<void> _onFetchMessagesStream(
      FetchMessagesStreamEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());

      FirebaseFirestore.instance
          .collection('chats')
          .doc(event.chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        final messages = snapshot.docs.map((doc) {
          return {
            'message': doc['message'],
            'senderId': doc['senderId'],
            'timestamp': doc['timestamp']
          };
        }).toList();

        add(MessagesFetched(messages));
      });
    } catch (e) {
      emit(NoChatFound('Error fetching messages: $e'));
    }
  }

  void _onMessagesFetched(MessagesFetched event, Emitter<ChatState> emit) {
    emit(MessagesLoaded(event.messages));
  }

  //Method to get the chat id
  Future<String> getOrCreateChatId(
      String currentUserId, String receiverId) async {
    final chatCollection = FirebaseFirestore.instance.collection('chats');

    // Query to check if a chat already exists between the users
    final querySnapshot = await chatCollection
        .where('participants', arrayContains: currentUserId)
        .get();

    for (var doc in querySnapshot.docs) {
      final participants = doc['participants'] as List;
      if (participants.contains(receiverId)) {
        // Chat exists, return the chatId
        return doc.id;
      }
    }

    // If no chat exists, create a new chat document
    final newChatDoc = await chatCollection.add({
      'participants': [currentUserId, receiverId],
      'createdAt': FieldValue.serverTimestamp(),
    });

    return newChatDoc.id;
  }
}
