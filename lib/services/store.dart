import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:projeto_final/models/chat_user.dart';
import 'package:projeto_final/models/message.dart';
import 'package:projeto_final/services/auth.dart';
import 'package:projeto_final/services/storage.dart';

class StoreService {
  static final FirebaseFirestore _store = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> getCollection(
    String collection,
  ) {
    return _store.collection(collection);
  }

  static User get _user => Auth().currentUser!;
  static late ChatUser self;

  static Future<void> createIfNotExists() async {
    var exists = await userExists();

    if (!exists) {
      await createUser();
    }
  }

  static Future<bool> userExists() async {
    var user = await _store.collection('users').doc(_user.uid).get();

    return user.exists;
  }

  static Future<void> createUser() async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    var name = _user.displayName != null
        ? _user.displayName.toString()
        : _user.email!.split('@')[0].capitalizeFirst!;

    final user = ChatUser(
      id: _user.uid,
      name: name,
      email: _user.email.toString(),
      status: "I'm using ZapZap",
      image: _user.photoURL?.toString(),
      createdAt: time,
    );

    return await _store.collection('users').doc(_user.uid).set(user.toJson());
  }

  static Future<void> loadSelf() async {
    var user = await _store.collection('users').doc(_user.uid).get();

    if (user.exists) {
      self = ChatUser.fromJson(user.data()!);
    } else {
      createUser();
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return _store
        .collection('users')
        .doc(_user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsers(
    List<String> userIds,
  ) {
    return _store.collection('users').where('id', whereIn: userIds).snapshots();
  }

  static Future<void> updateUserInfo() async {
    await _store
        .collection('users')
        .doc(_user.uid)
        .update({'name': self.name, 'status': self.status});
  }

  static Future<void> updateProfileImage(File file) async {
    final ext = file.path.split('.').last;

    final ref =
        StorageService.getRef().child('profile_pictures/${_user.uid}.$ext');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then(
        (p0) => {log('Data transferred: ${p0.bytesTransferred / 1000}kb')});

    self.image = await ref.getDownloadURL();

    await _store
        .collection('users')
        .doc(_user.uid)
        .update({'image': self.image});
  }

  static String _getConversationId(String id) =>
      _user.uid.hashCode <= id.hashCode
          ? '${_user.uid}_$id'
          : '${id}_${_user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    ChatUser user,
  ) {
    return _store
        .collection('chats/${_getConversationId(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser user, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
      toId: user.id,
      message: msg,
      fromId: _user.uid,
      sent: time,
    );

    final ref =
        _store.collection('chats/${_getConversationId(user.id)}/messages/');

    await ref.doc(time).set(message.toJson());
  }

  static Future<bool> addChatUser(String email) async {
    final data =
        await _store.collection('users').where('email', isEqualTo: email).get();

    if (data.docs.isNotEmpty && data.docs.first.id != _user.uid) {
      _store
          .collection('users')
          .doc(_user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      _store
          .collection('users')
          .doc(data.docs.first.id)
          .collection('my_users')
          .doc(_user.uid)
          .set({});

      return true;
    }

    return false;
  }
}
