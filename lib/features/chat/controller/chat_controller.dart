// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/enums/message_enum.dart';
import 'package:my_chat/common/provider/message_reply_provider.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';

import 'package:my_chat/features/chat/repository/chat_repository.dart';
import 'package:my_chat/models/chat_contact.dart';
import 'package:my_chat/models/group_model.dart';
import 'package:my_chat/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<GroupModel>> chatGroups() {
    return chatRepository.getGroupsContacts();
  }

  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String receiverUserId,
      required bool isGroupChat}) async {
    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            isGroupChat: isGroupChat,
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!,
            messageReply: messageReply));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendFileMessage(
      {required BuildContext context,
      required File file,
      required String receiverUserId,
      required MessageEnum fileType,
      required bool isGroupChat}) async {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendFileMessage(
              isGroupChat: isGroupChat,
              context: context,
              file: file,
              fileType: fileType,
              ref: ref,
              receiverUserId: receiverUserId,
              senderUser: value!,
              messageReply: messageReply,
            ));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverUserId,
    required String senderUserId,
    required String messageId,
  }) {
    chatRepository.setChatMessageSeen(
      context: context,
      receiverUserId: receiverUserId,
      senderUserId: senderUserId,
      messageId: messageId,
    );
  }
}
