// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:my_chat/common/enums/message_enum.dart';
import 'package:my_chat/features/chat/widgets/message_content.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final String date;
  final VoidCallback onLeftSwipe;
  final String repliedText;
  final String repliedToUser;
  final MessageEnum repliedType;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.type,
    required this.date,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.repliedToUser,
    required this.repliedType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 120),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: tabColor,
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
                    children: [
                      isReplying
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(
                                        color: backgroundColor, width: 3)),
                              ),
                              child: Column(
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
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                      MessageContent(
                        message: message,
                        type: type,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.white60,
                      ),
                    ],
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
