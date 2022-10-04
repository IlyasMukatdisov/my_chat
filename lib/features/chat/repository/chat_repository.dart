// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_chat/common/enums/message_enum.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/models/chat_contact.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/utils/app_constants.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSend = DateTime.now();
      UserModel receiverUserData;
      var userDataMap = await firestore
          .collection(AppConstants.usersCollection)
          .doc(receiverUserId)
          .get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactsSubCollection(
          senderUserData: senderUser,
          receiverUserData: receiverUserData,
          text: text,
          timeSent: timeSend);

      _saveMessageToMessageSubCollection();
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  void _saveDataToContactsSubCollection({
    required UserModel senderUserData,
    required UserModel receiverUserData,
    required String text,
    required DateTime timeSent,
  }) async {
    var receiverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSend: timeSent,
        lastMessage: text);

    await firestore
        .collection(AppConstants.usersCollection)
        .doc(receiverUserData.uid)
        .collection(AppConstants.chatsCollection)
        .doc(senderUserData.uid)
        .set(
          receiverChatContact.toMap(),
        );

    var senderChatContact = ChatContact(
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSend: timeSent,
        lastMessage: text);

    await firestore
        .collection(AppConstants.usersCollection)
        .doc(senderUserData.uid)
        .collection(AppConstants.chatsCollection)
        .doc(receiverUserData.uid)
        .set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String receiverUserName,
    required MessageEnum messageEnum,
  }) {}
}
