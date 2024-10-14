import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isUser;

  const MessageBubble({required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent.withOpacity(0.7) : Colors.grey.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          content,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
