import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_final/models/chat_user.dart';
import 'package:projeto_final/screens/splash_screen.dart';
import 'package:projeto_final/services/auth.dart';
import 'package:projeto_final/services/store.dart';
import 'package:projeto_final/utils/dialog.dart';
import 'package:projeto_final/widgets/spacer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ProfileScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'Perfil',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.green,
    );
  }

  Widget _profileImage() {
    return Stack(
      children: [
        SizedBox(
          width: mq.height * .2,
          height: mq.height * .2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              child: widget.user.image != null
                  ? Image.network(widget.user.image ?? _image!)
                  : _image != null
                      ? Image.file(File(_image!))
                      : Icon(Icons.person, size: mq.height * .1),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -20,
          child: MaterialButton(
            onPressed: () {
              _showPictureSheet();
            },
            elevation: 1,
            color: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.edit,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }

  TextFormField _statusField() {
    return TextFormField(
      initialValue: widget.user.status,
      onSaved: (value) => StoreService.self.status = value ?? '',
      validator: (value) =>
          value != null && value.isNotEmpty ? null : 'Campo obrigatório',
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.info_outline),
        border: OutlineInputBorder(),
        hintText: 'Digite seu status',
        label: Text('Status'),
      ),
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      initialValue: widget.user.name,
      onSaved: (value) => StoreService.self.name = value ?? '',
      validator: (value) =>
          value != null && value.isNotEmpty ? null : 'Campo obrigatório',
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
        hintText: 'Digite seu nome',
        label: Text('Nome'),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: source, imageQuality: 80);

    if (image != null) {
      Navigator.pop(context);

      await StoreService.updateProfileImage(File(image.path));

      setState(() {
        _image = image.path;
      });
    }
  }

  void _showPictureSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              const Text(
                'Selecione uma nova foto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * .3, mq.height * .15),
                    ),
                    onPressed: () => pickImage(ImageSource.camera),
                    child: const Icon(Icons.add_a_photo_outlined, size: 48),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      fixedSize: Size(mq.width * .3, mq.height * .15),
                    ),
                    onPressed: () => pickImage(ImageSource.gallery),
                    child: const Icon(Icons.photo, size: 48),
                  ),
                ],
              )
            ],
          );
        });
  }

  ElevatedButton _updateButton() {
    return ElevatedButton.icon(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          StoreService.updateUserInfo().then((value) => {
                DialogUtils.showSnackbar(
                    context, 'Perfil atualizado com sucesso!')
              });
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        minimumSize: Size(mq.width * .5, mq.height * .06),
      ),
      icon: const Icon(
        Icons.edit,
        size: 24,
      ),
      label: const Text('Atualizar'),
    );
  }

  Widget _body() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ItemSpacer(),
              _profileImage(),
              const ItemSpacer(),
              Text(
                widget.user.email,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              const ItemSpacer(),
              _nameField(),
              const ItemSpacer(space: 0.02),
              _statusField(),
              const ItemSpacer(),
              _updateButton(),
              const ItemSpacer(space: 0.02),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              await Auth().signOut();
              Get.back();
            },
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            backgroundColor: Colors.redAccent,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Sair',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
