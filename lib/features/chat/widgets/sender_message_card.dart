// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:my_chat/common/enums/message_enum.dart';
import 'package:my_chat/features/chat/widgets/message_content.dart';
import 'package:my_chat/models/message.dart';
import 'package:my_chat/utils/colors.dart';

class SenderMessageCard extends ConsumerWidget {
  final Message message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String repliedToUser;
  final MessageEnum repliedType;
  final bool isGroupChat;

  String profilePic = '';
  String senderName = '';

  SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.repliedToUser,
    required this.repliedType,
    required this.isGroupChat,
  }) : super(key: key);

  void setGroupMessage(WidgetRef ref) async {
    final user =
        await ref.read(authControllerProvider).getUserData(message.senderId);

    if (user != null) {
      profilePic = user.profilePic;
      senderName = user.name;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isGroupChat) {
      setGroupMessage(ref);
    }

    final bool isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 120),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10,
                          right: 30,
                          top: 5,
                          bottom: 20,
                        )
                      : const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 5,
                          bottom: 30,
                        ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isReplying
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                    left:
                                        BorderSide(color: tabColor, width: 3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    repliedToUser,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  MessageContent(
                                    message: repliedText,
                                    type: repliedType,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          isGroupChat
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(profilePic),
                                )
                              : const SizedBox(),
                          isGroupChat
                              ? const SizedBox(
                                  width: 5,
                                )
                              : const SizedBox(),
                          MessageContent(
                            message: message.text,
                            type: type,
                            isGroupChat: isGroupChat,
                            name: senderName,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
