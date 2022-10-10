// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_chat/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageType;
  final String replyMessageOwner;

  MessageReply({
    required this.message,
    required this.isMe,
    required this.messageType,
    required this.replyMessageOwner,
  });
}

final messageReplyProvider = StateProvider<MessageReply?>(
  (ref) => null,
);
