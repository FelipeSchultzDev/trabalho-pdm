import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projeto_final/models/chat_user.dart';
import 'package:projeto_final/models/message.dart';
import 'package:projeto_final/screens/splash_screen.dart';
import 'package:projeto_final/services/store.dart';
import 'package:projeto_final/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [
            _messages(),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _messages() {
    return Expanded(
      child: StreamBuilder(
        stream: StoreService.getAllMessages(widget.user),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: list.length,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var message = list[index];
                    return MessageCard(message: message);
                  },
                );
              }

              return const Center(
                child: Text(
                  'Sem mensagens',
                  style: TextStyle(fontSize: 20),
                ),
              );
          }
        },
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mq.height * .01,
        horizontal: mq.width * .025,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: const LinearBorder(),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.gps_fixed,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      decoration: const InputDecoration(
                        hintText: 'Digite uma mensagem...',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                StoreService.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            padding: const EdgeInsets.all(10),
            shape: const CircleBorder(),
            minWidth: 0,
            child: const Icon(
              Icons.send,
              color: Colors.black,
              size: 28,
            ),
          )
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 1,
      automaticallyImplyLeading: false,
      flexibleSpace: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.black54),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              child: widget.user.image != null
                  ? Image.network(widget.user.image!)
                  : const Icon(Icons.person),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
