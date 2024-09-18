import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/home_screen_widget/app_bar_widget.dart';

class ChatScreen extends StatelessWidget {
  final String userTitle;
  final String photoURL;
  const ChatScreen(
      {super.key, required this.userTitle, required this.photoURL});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showNotificationIcon: false,
        isBackNeeded: true,
        title: userTitle,
        isProfileImage: true,
        photoURL: photoURL,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: [
                // Example messages
                ChatMessage(message: "Hello!", isMe: true),
                ChatMessage(message: "Hi there!", isMe: false),
                // Add more ChatMessage widgets here
              ],
            ),
          ),
          ChatInput(),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isMe;

  ChatMessage({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class ChatInput extends StatefulWidget {
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    // Handle message send action here
    final message = _controller.text;
    if (message.isNotEmpty) {
      print("Sending message: $message");
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40.h,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.green, // Customize your color here
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
