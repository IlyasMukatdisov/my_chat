// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/enums/message_enum.dart';
import 'package:my_chat/common/provider/message_reply_provider.dart';
import 'package:my_chat/common/repository/common_firebase_storage_repository.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/chat_contact.dart';
import 'package:my_chat/models/group_model.dart';
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
        .orderBy('timeSent', descending: false)
        .snapshots()
        .map(
      (event) {
        List<ChatContact> contacts = [];
        for (var document in event.docs) {
          var chatContact = ChatContact.fromMap(document.data());
          contacts.add(chatContact);
        }
        return contacts;
      },
    );
  }

  Stream<List<GroupModel>> getGroupsContacts() {
    return firestore.collection(AppConstants.groupCollection).snapshots().map(
      (collection) {
        List<GroupModel> groups = [];
        for (var document in collection.docs) {
          var group = GroupModel.fromMap(document.data());
          if (group.membersUid.contains(auth.currentUser!.uid)) {
            groups.add(group);
          }
        }
        return groups;
      },
    );
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection(AppConstants.usersCollection)
        .doc(auth.currentUser!.uid)
        .collection(AppConstants.chatsCollection)
        .doc(receiverUserId)
        .collection(AppConstants.messagesCollection)
        .orderBy('timeSent', descending: false)
        .snapshots()
        .map(
      (event) {
        List<Message> messages = [];
        for (var doc in event.docs) {
          messages.add(Message.fromMap(doc.data()));
        }
        return messages;
      },
    );
  }

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return firestore
        .collection(AppConstants.groupCollection)
        .doc(groupId)
        .collection(AppConstants.chatsCollection)
        .orderBy('timeSent', descending: false)
        .snapshots()
        .map(
      (event) {
        List<Message> messages = [];
        for (var doc in event.docs) {
          messages.add(Message.fromMap(doc.data()));
        }
        return messages;
      },
    );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var messageId = Uuid().v1();
      var timeSend = DateTime.now();

      UserModel? receiverUserData;

      if (!isGroupChat) {
        var userDataMap = await firestore
            .collection(AppConstants.usersCollection)
            .doc(receiverUserId)
            .get();
        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      _saveDataToContactsSubCollection(
        senderUserData: senderUser,
        receiverUserData: receiverUserData,
        text: text,
        receiverUserId: receiverUserId,
        timeSent: timeSend,
        isGroupChat: isGroupChat,
      );

      _saveMessageToMessageSubCollection(
          senderUserId: senderUser.uid,
          receiverUserId: receiverUserId,
          text: text,
          timeSent: timeSend,
          messageType: MessageEnum.text,
          messageId: messageId,
          receiverUserName: receiverUserData?.name,
          senderUserName: senderUser.name,
          messageReply: messageReply,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  void _saveDataToContactsSubCollection({
    required UserModel senderUserData,
    required UserModel? receiverUserData,
    required String text,
    required DateTime timeSent,
    required bool isGroupChat,
    required String receiverUserId,
  }) async {
    if (isGroupChat) {
      await firestore
          .collection(AppConstants.groupCollection)
          .doc(receiverUserId)
          .update({
        'lastMessage': text,
        'senderName': senderUserData.name,
        'timeSent': timeSent.millisecondsSinceEpoch
      });
    } else {
      var receiverChatContact = ChatContact(
          name: senderUserData.name,
          profilePic: senderUserData.profilePic,
          contactId: senderUserData.uid,
          timeSent: timeSent,
          lastMessage: text);

      await firestore
          .collection(AppConstants.usersCollection)
          .doc(receiverUserData!.uid)
          .collection(AppConstants.chatsCollection)
          .doc(senderUserData.uid)
          .set(
            receiverChatContact.toMap(),
          );

      var senderChatContact = ChatContact(
          name: receiverUserData.name,
          profilePic: receiverUserData.profilePic,
          contactId: receiverUserData.uid,
          timeSent: timeSent,
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
  }

  void _saveMessageToMessageSubCollection({
    required String senderUserId,
    required String receiverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String senderUserName,
    required String? receiverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    final message = Message(
        senderId: senderUserId,
        receiverId: receiverUserId,
        text: text,
        type: messageType,
        timeSent: timeSent,
        messageId: messageId,
        isSeen: false,
        repliedMessage: messageReply == null ? '' : messageReply.message,
        repliedToUser: messageReply == null
            ? ''
            : messageReply.isMe
                ? senderUserName
                : receiverUserName ?? '',
        repliedType:
            messageReply == null ? MessageEnum.text : messageReply.messageType);
    if (isGroupChat) {
      await firestore
          .collection(AppConstants.groupCollection)
          .doc(receiverUserId)
          .collection(AppConstants.chatsCollection)
          .doc(messageId)
          .set(message.toMap());
    } else {
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

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUser,
    required ProviderRef ref,
    required MessageEnum fileType,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      final timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      String fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeToFirebase(
              path:
                  'chat/${fileType.type}/${senderUser.uid}/$receiverUserId/$messageId',
              file: file);

      UserModel? receiverUserData;
      if (!isGroupChat) {
        var userDataMap = await firestore
            .collection(AppConstants.usersCollection)
            .doc(receiverUserId)
            .get();
        receiverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      String contactMsg = '';

      switch (fileType) {
        case MessageEnum.text:
          contactMsg = 'text';
          break;
        case MessageEnum.image:
          contactMsg = '📷 image';
          break;
        case MessageEnum.audio:
          contactMsg = '🔉 audio';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 video';
          break;
        case MessageEnum.gif:
          contactMsg = '📺 GIF';
          break;
      }
      _saveDataToContactsSubCollection(
          senderUserData: senderUser,
          receiverUserData: receiverUserData,
          text: contactMsg,
          timeSent: timeSent,
          isGroupChat: isGroupChat,
          receiverUserId: receiverUserId);
      _saveMessageToMessageSubCollection(
          isGroupChat: isGroupChat,
          senderUserId: senderUser.uid,
          receiverUserId: receiverUserId,
          text: fileUrl,
          timeSent: timeSent,
          messageId: messageId,
          senderUserName: senderUser.name,
          receiverUserName: receiverUserData?.name,
          messageType: fileType,
          messageReply: messageReply);
    } catch (e) {
      showSnackBar(
          context: context, text: AppLocalizations.of(context).cant_send_file);
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String senderUserId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection(AppConstants.usersCollection)
          .doc(senderUserId)
          .collection(AppConstants.chatsCollection)
          .doc(receiverUserId)
          .collection(AppConstants.messagesCollection)
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection(AppConstants.usersCollection)
          .doc(receiverUserId)
          .collection(AppConstants.chatsCollection)
          .doc(senderUserId)
          .collection(AppConstants.messagesCollection)
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }
}
