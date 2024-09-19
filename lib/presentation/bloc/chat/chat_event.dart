abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String message;
  final String receiverId;

  SendMessageEvent(this.chatId, this.message, this.receiverId);
}

class FetchMessagesStreamEvent extends ChatEvent {
  final String chatId;

  FetchMessagesStreamEvent(this.chatId);
}

class MessagesFetched extends ChatEvent {
  final List<Map<String, dynamic>> messages;

  MessagesFetched(this.messages);
}
