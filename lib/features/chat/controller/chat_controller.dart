// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';

import 'package:my_chat/features/chat/repository/chat_repository.dart';
import 'package:my_chat/models/user_model.dart';

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String receiverUserId,
      required String senderUserId}) async {
        ref.read(userDataAuthProvider).whenData((value) => null)

    chatRepository.sendTextMessage(
        context: context,
        text: text,
        receiverUserId: receiverUserId,
        senderUser: senderUser);
  }
}
