// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/repository/common_firebase_storage_repository.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/select_contact/controller/select_contact_controller.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/status_model.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/utils/app_constants.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

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
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeToFirebase(
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
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch)
          .get();

      if (statusesSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusesSnapshot.docs.first.data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await firestore
            .collection(AppConstants.statusCollection)
            .doc(statusesSnapshot.docs.first.id)
            .update({
          'photoUrl': statusImageUrls,
        });
        return;
      } else {
        statusImageUrls = [imageUrl];
      }
      Status status = Status(
        uid: uid,
        username: userName,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdDate: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await firestore
          .collection(AppConstants.statusCollection)
          .doc(statusId)
          .set(status.toMap());
    } catch (e) {
      showSnackBar(
          context: context, text: AppLocalizations.of(context).cant_send_file);
    }
  }

  Future<List<Status>> getStatus({required BuildContext context}) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts =
          await ref.read(selectContactControllerProvider).getContacts();

      var statusesSnapshot = await firestore
          .collection(AppConstants.statusCollection)
          .where('createdDate',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch)
          .get();
      for (var contact in contacts) {
        String contactNumber = contact.phones.first.normalizedNumber.isNotEmpty
            ? contact.phones.first.normalizedNumber.replaceAll(' ', '')
            : contact.phones.first.number.replaceAll(' ', '');

        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid) &&
              tempStatus.phoneNumber == contactNumber) {
            statusData.add(tempStatus);
          }
        }
        // !Not Optimized Code
        // var statusesSnapshot = await firestore
        //     .collection(AppConstants.statusCollection)
        //     .where('phoneNumber',
        //         isEqualTo: contact.phones.first.normalizedNumber.isNotEmpty
        //             ? contact.phones.first.normalizedNumber.replaceAll(' ', '')
        //             : contact.phones.first.number.replaceAll(' ', ''))
        //     .where('createdDate',
        //         isGreaterThan: DateTime.now()
        //             .subtract(const Duration(hours: 24))
        //             .millisecondsSinceEpoch)
        //     .get();
        // for (var tempData in statusesSnapshot.docs) {
        //   Status tempStatus = Status.fromMap(tempData.data());
        //   if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
        //     statusData.add(tempStatus);
        //   }
        // }
      }
    } catch (e) {
      showSnackBar(
          context: context, text: AppLocalizations.of(context).cant_load_data);
    }
    return statusData;
  }
}
