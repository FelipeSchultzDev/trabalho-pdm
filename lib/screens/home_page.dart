import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:projeto_final/models/chat_user.dart';
import 'package:projeto_final/screens/chat_screen.dart';
import 'package:projeto_final/screens/profile_page.dart';
import 'package:projeto_final/screens/splash_screen.dart';
import 'package:projeto_final/services/auth.dart';
import 'package:projeto_final/services/store.dart';
import 'package:projeto_final/utils/dialog.dart';
import 'package:projeto_final/widgets/chat_user_card.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  void initState() {
    super.initState();
    StoreService.loadSelf();
  }

  Future<String> readQrCode() async {
    return await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: _newChat(),
    );
  }

  showQrCode() {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: SizedBox(
              height: mq.height * .4,
              width: mq.height * .4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: Auth().currentUser!.email!,
                    size: mq.height * .3,
                  ),
                ],
              ),
            ),
          );
        });
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'ZapZap',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          onPressed: showQrCode,
          icon: const Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            Get.to(
              () => ProfileScreen(
                user: StoreService.self,
              ),
            );
          },
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
      ],
      backgroundColor: Colors.green,
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> _body() {
    return StreamBuilder(
        stream: StoreService.getMyUsersId(),
        builder: (context, chatsSnapshot) {
          switch (chatsSnapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              final ids =
                  chatsSnapshot.data?.docs.map((e) => e.id).toList() ?? [];

              if (ids.isEmpty) {
                return Container();
              }

              return StreamBuilder(
                stream: StoreService.getUsers(ids),
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
                      list = data
                              ?.map((e) => ChatUser.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: list.length,
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var user = list[index];
                            return ChatUserCard(
                              user: user,
                              onChatTap: () =>
                                  Get.to(() => ChatScreen(user: user)),
                            );
                          },
                        );
                      }

                      return const Center(
                        child: Text(
                          'Sem contatos',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                  }
                },
              );
          }
        });
  }

  Widget _newChat() {
    return FloatingActionButton(
      onPressed: () async {
        var email = await readQrCode();

        if (email.isNotEmpty) {
          await StoreService.addChatUser(email).then((value) {
            if (!value) {
              DialogUtils.showSnackbar(
                context,
                'Não foi possível adicionar usuário',
              );
            }
          });
        }
      },
      backgroundColor: Colors.green,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add_comment_rounded,
        color: Colors.white,
      ),
    );
  }
}
