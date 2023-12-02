import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static FirebaseStorage _storage = FirebaseStorage.instance;

  static Reference getRef() {
    return _storage.ref();
  }
}
