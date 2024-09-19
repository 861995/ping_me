abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class NoChatFound extends ChatState {
  final String message;

  NoChatFound(this.message);
}

class MessagesLoaded extends ChatState {
  final List<Map<String, dynamic>> messages;

  MessagesLoaded(this.messages);
}
