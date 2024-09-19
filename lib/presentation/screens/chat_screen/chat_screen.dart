import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:we_chat/presentation/utils/app_fonts.dart';

import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/chat/chat_event.dart';
import '../../bloc/chat/chat_state.dart';
import '../../widgets/chat_widgets/chat_bubble_widget.dart';
import '../../widgets/home_screen_widget/app_bar_widget.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userTitle;
  final String photoURL;
  final String recieverId;
  final String currentUserID;

  const ChatScreen(
      {super.key,
      required this.chatId,
      required this.photoURL,
      required this.recieverId,
      required this.currentUserID,
      required this.userTitle});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<ChatScreenBloc>().add(FetchMessagesStreamEvent(widget.chatId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showNotificationIcon: false,
        isBackNeeded: true,
        title: widget.userTitle,
        isProfileImage: true,
        photoURL: widget.photoURL,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocProvider(
              create: (context) => ChatScreenBloc()
                ..add(FetchMessagesStreamEvent(widget.chatId)),
              child: BlocBuilder<ChatScreenBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is MessagesLoaded) {
                    return state.messages.isNotEmpty
                        ? ListView.builder(
                            reverse: true,
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              widget.recieverId;
                              widget.currentUserID;

                              final message = state.messages[index];

                              return ListTile(
                                // title: Text(message['message']),
                                title: ChatBubbleWidget(
                                    message: message['message'],
                                    isMe: message['senderId'] ==
                                        widget.currentUserID),
                              );
                            },
                          )
                        : noChatWidget();
                  } else if (state is NoChatFound) {
                    return noChatWidget();
                  }
                  return const Center(child: Text('Start chatting!'));
                },
              ),
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Enter your message...",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final message = _messageController.text;
              if (message.isNotEmpty) {
                context.read<ChatScreenBloc>().add(SendMessageEvent(
                    widget.chatId, message, widget.recieverId));
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget noChatWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset("assets/lottie/say_HI.json",
            repeat: false, height: 200.h, width: 200.w),
        Text(
          'Ping MEEE!',
          style: AppFonts.boldFont,
        )
      ],
    );
  }
}
