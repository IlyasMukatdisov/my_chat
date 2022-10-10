// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_chat/common/enums/message_enum.dart';

class MessageReply {
  final String message;
  final String messageOwnerName;
  final bool isMe;
  final MessageEnum messageType;

  MessageReply({
    required this.message,
    required this.messageOwnerName,
    required this.isMe,
    required this.messageType,
  });
}

final messageReplyProvider = StateProvider<MessageReply?>(
  (ref) => null,
);
