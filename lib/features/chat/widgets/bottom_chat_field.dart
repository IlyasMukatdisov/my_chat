// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';

import 'package:my_chat/features/chat/controller/chat_controller.dart';
import 'package:my_chat/utils/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({
    Key? key,
    required this.receiverUserId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isTextEmpty = true;
  late final TextEditingController _messageController;

  @override
  void initState() {
    _messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendTextMessage() async {
    final senderUser =
        await ref.read(authControllerProvider).getCurrentUserData();
    if (!isTextEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
          context: context,
          text: _messageController.text.trim(),
          receiverUserId: widget.receiverUserId,
          senderUserId: senderUser!.uid);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: _messageController,
              onChanged: (value) {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    isTextEmpty = false;
                  });
                } else {
                  setState(() {
                    isTextEmpty = true;
                  });
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                prefixIcon: isTextEmpty
                    ? Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.white54,
                              ),
                            ),
                            InkWell(
                              child: const Icon(
                                Icons.gif,
                                color: Colors.white54,
                              ),
                              onTap: () {},
                            )
                          ],
                        ),
                      )
                    : null,
                suffixIcon: isTextEmpty
                    ? Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white54,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.attach_file,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
                hintText: 'Type a message!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          CircleAvatar(
            backgroundColor: tabColor,
            child: GestureDetector(
              onTap: () {
                if (!isTextEmpty) {
                  sendTextMessage();
                }
              },
              child: Icon(
                isTextEmpty ? Icons.mic : Icons.send_rounded,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
