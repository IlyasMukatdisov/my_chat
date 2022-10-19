// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';

import 'package:my_chat/features/call/repository/call_repository.dart';
import 'package:my_chat/models/call.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider(
  (ref) => CallController(
    callRepository: ref.watch(callRepositoryProvider),
    ref: ref,
  ),
);

class CallController {
  final CallRepository callRepository;
  ProviderRef ref;

  CallController({
    required this.callRepository,
    required this.ref,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void createCall({
    required String receiverUserName,
    required BuildContext context,
    required String receiverUid,
    required String receiverProfilePic,
    required bool isGroupChat,
  }) {
    String callId = const Uuid().v1();

    ref.read(userDataAuthProvider).whenData((value) {
      CallModel callData = CallModel(
          callerId: value!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          receiverId: receiverUid,
          receiverName: receiverUserName,
          receiverPic: receiverUserName,
          callId: callId,
          hasDialed: false);

      callRepository.createCall(
        callData: callData,
        context: context,
      );
    });
  }

  void endCall({
    required String receiverId,
    required String callerId,
    required BuildContext context,
  }) async {
    callRepository.endCall(
      callerId: callerId,
      receiverId: receiverId,
      context: context,
    );
  }
}
