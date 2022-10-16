// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/repository/common_firebase_storage_repository.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/group_model.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/utils/app_constants.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required String name,
    required File profilePic,
    required List<Contact> selectedContacts,
  }) async {
    try {
      List<String> uids = [];
      var timeSent = DateTime.now();
      List<UserModel> users = [];

      var usersSnapshot =
          await firestore.collection(AppConstants.usersCollection).get();

      for (var doc in usersSnapshot.docs) {
        users.add(UserModel.fromMap(doc.data()));
      }
      for (var user in users) {
        for (var contact in selectedContacts) {
          String phoneNumber = contact.phones.first.normalizedNumber
                  .replaceAll(' ', '')
                  .isNotEmpty
              ? contact.phones.first.normalizedNumber.replaceAll(' ', '')
              : contact.phones.first.number.replaceAll(' ', '');
          if (user.phoneNumber == phoneNumber) {
            uids.add(user.uid);
          }
        }
      }

      if (!uids.contains(auth.currentUser!.uid)) {
        uids.add(auth.currentUser!.uid);
      }

      var groupId = const Uuid().v1();

      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeToFirebase(
            path: '${AppConstants.groupCollection}/$groupId',
            file: profilePic,
          );

      var curUserData = await firestore.collection(AppConstants.usersCollection).doc(auth.currentUser!.uid).snapshots().first;
      UserModel currentUser = UserModel.fromMap(curUserData.data()!) ;

      GroupModel group = GroupModel(
        name: name,
        senderId: auth.currentUser!.uid,
        groupProfilePic: profileUrl,
        groupUid: groupId,
        lastMessage: '',
        membersUid: uids,
        timeSent: timeSent,
        senderName: currentUser.name
      );

      await firestore
          .collection(AppConstants.groupCollection)
          .doc(groupId)
          .set(group.toMap());
    } catch (e) {
      showSnackBar(
        context: context,
        text: AppLocalizations.of(context).cant_create_group,
      );
    }
  }
}
