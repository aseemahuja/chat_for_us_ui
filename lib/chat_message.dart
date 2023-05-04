import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final Widget text;
  final String sender;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.sender)
            .text
            .subtitle1(context)
            .make()
            .box
            .color(widget.sender == "Me" ? Vx.red200 : Vx.green200)
            .p16
            .rounded
            .alignCenter
            .makeCentered(),
        Expanded(
          child: widget.text,
        )
      ],
    ).py8();
  }
}
