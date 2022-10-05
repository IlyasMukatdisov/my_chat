// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/enums/message_enum.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/models/chat_contact.dart';
import 'package:my_chat/models/message.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/utils/app_constants.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection(AppConstants.usersCollection)
        .doc(auth.currentUser!.uid)
        .collection(AppConstants.chatsCollection)
        .snapshots()
        .asyncMap(
      (event) async {
        List<ChatContact> contacts = [];
        for (var document in event.docs) {
          var chatContact = ChatContact.fromMap(document.data());
          contacts.add(chatContact);
          // var userData = await firestore
          //     .collection(AppConstants.usersCollection)
          //     .doc(chatContact.contactId)
          //     .get();
          // var user = UserModel.fromMap(userData.data()!);
          // contacts.add(ChatContact(
          //     name: user.name,
          //     profilePic: user.profilePic,
          //     contactId: chatContact.contactId,
          //     timeSend: chatContact.timeSend,
          //     lastMessage: chatContact.contactId));
        }
        return contacts;
      },
    );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var messageId = Uuid().v1();
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

      _saveMessageToMessageSubCollection(
          senderUserId: senderUser.uid,
          receiverUserId: receiverUserId,
          text: text,
          timeSent: timeSend,
          messageType: MessageEnum.text,
          messageId: messageId,
          receiverUserName: receiverUserData.name,
          senderUserName: senderUser.name);
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
    required String senderUserId,
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String senderUserName,
    required String receiverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
        senderId: senderUserId,
        receiverId: receiverUserId,
        text: text,
        type: MessageEnum.text,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false);

    await firestore
        .collection(AppConstants.usersCollection)
        .doc(senderUserId)
        .collection(AppConstants.chatsCollection)
        .doc(receiverUserId)
        .collection(AppConstants.messagesCollection)
        .doc(messageId)
        .set(message.toMap());

    await firestore
        .collection(AppConstants.usersCollection)
        .doc(receiverUserId)
        .collection(AppConstants.chatsCollection)
        .doc(senderUserId)
        .collection(AppConstants.messagesCollection)
        .doc(messageId)
        .set(message.toMap());
  }
}
