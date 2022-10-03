import 'package:flutter/material.dart';
import 'package:my_chat/utils/colors.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isTextEmpty = true;

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
              onChanged: (value) {
                if (value.isNotEmpty) {
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
            child: IconButton(
              icon: Icon(
                isTextEmpty ? Icons.send_rounded : Icons.mic,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
