import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  (ref) => CommonFirebaseStorageRepository(
      firebaseStorage: FirebaseStorage.instance),
);

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  CommonFirebaseStorageRepository({required this.firebaseStorage});

  Future<String> storeToFirebase({
    required String path,
    required File file,
  }) async {
    UploadTask uploadTask = firebaseStorage.ref().child(path).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
