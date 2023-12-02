import 'package:flutter/material.dart';
import 'package:projeto_final/models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  final Function? onChatTap;

  const ChatUserCard({super.key, required this.user, this.onChatTap});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onChatTap != null) {
          widget.onChatTap!();
        }
      },
      child: Card(
        margin: const EdgeInsets.all(1),
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        shadowColor: Colors.transparent,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              child: widget.user.image != null
                  ? Image.network(widget.user.image!)
                  : const Icon(Icons.person),
            ),
          ),
          title: Text(widget.user.name),
          subtitle: Text(
            widget.user.status,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
