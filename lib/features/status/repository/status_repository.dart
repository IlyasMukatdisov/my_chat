// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/repository/common_firebase_storage_repository.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/select_contact/controller/select_contact_controller.dart';
import 'package:my_chat/features/select_contact/repository/select_contact_repository.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/utils/app_constants.dart';
import 'package:uuid/uuid.dart';

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String userName,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = Uuid().v1();
      String uid = auth.currentUser!.uid;
      ref.read(commonFirebaseStorageRepositoryProvider).storeToFirebase(
          path: '/${AppConstants.statusCollection}/$statusId$uid',
          file: statusImage);
      var contacts =
          await ref.read(selectContactControllerProvider).getContacts();
      List<String> uidWhoCanSee = [];
      for (var contact in contacts) {
        var userDataFromFirebase = await firestore
            .collection(AppConstants.usersCollection)
            .where('phoneNumber',
                isEqualTo: contact.phones.first.normalizedNumber.isNotEmpty
                    ? contact.phones.first.normalizedNumber.replaceAll(' ', '')
                    : contact.phones.first.number.replaceAll(' ', ''))
            .get();
        if (userDataFromFirebase.docs.isNotEmpty) {
          var userData =
              UserModel.fromMap(userDataFromFirebase.docs.first.data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusImageUrls = [];
      var statusesSnapshot = await firestore
          .collection(AppConstants.statusCollection)
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .where('createdDate',
              isLessThan: DateTime.now().subtract(const Duration(hours: 24)))
          .get();
    } catch (e) {
      showSnackBar(
          context: context, text: AppLocalizations.of(context).cant_send_file);
    }
  }
}
