// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/call/screens/call_screen.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/call.dart';
import 'package:my_chat/utils/app_constants.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  void createCall({
    required CallModel callData,
    required BuildContext context,
  }) async {
    try {
      await firestore
          .collection(AppConstants.callCollection)
          .doc(callData.callerId)
          .set(callData.toMap());
      await firestore
          .collection(AppConstants.callCollection)
          .doc(callData.receiverId)
          .set(callData.toMap());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
              channelId: callData.callId,
              call: callData,
              isGroupChat: false),
        ),
      );
    } catch (e) {
      showSnackBar(
        context: context,
        text: AppLocalizations.of(context).cant_create_group,
      );
    }
  }

  Stream<DocumentSnapshot> get callStream => firestore
      .collection(AppConstants.callCollection)
      .doc(auth.currentUser!.uid)
      .snapshots();
}
