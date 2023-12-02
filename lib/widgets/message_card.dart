import 'package:flutter/material.dart';
import 'package:projeto_final/models/message.dart';
import 'package:projeto_final/screens/splash_screen.dart';
import 'package:projeto_final/services/auth.dart';
import 'package:projeto_final/utils/date.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Auth().currentUser!.uid == widget.message.fromId
        ? _sentMessage()
        : _receivedMessage();
  }

  Widget _receivedMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(widget.message.message),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            DateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
          ),
        ),
      ],
    );
  }

  Widget _sentMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: mq.width * .04),
          child: Text(
            DateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(widget.message.message),
          ),
        ),
      ],
    );
  }
}
