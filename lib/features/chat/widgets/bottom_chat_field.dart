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
  bool isShowSendButton = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    isShowSendButton = true;
                  });
                } else {
                  setState(() {
                    isShowSendButton = false;
                  });
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                // prefixIcon: Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //   child: Row(
                //     children: [
                //       InkWell(
                //         onTap: () {},
                //         child: const Icon(
                //           Icons.emoji_emotions,
                //           color: Colors.white54,
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       InkWell(
                //         child: const Icon(
                //           Icons.gif,
                //           color: Colors.white54,
                //         ),
                //         onTap: () {},
                //       )
                //     ],
                //   ),
                // ),
                // suffixIcon: Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       InkWell(
                //         onTap: () {},
                //         child: const Icon(
                //           Icons.camera_alt,
                //           color: Colors.white54,
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 10,
                //       ),
                //       InkWell(
                //         onTap: () {},
                //         child: const Icon(
                //           Icons.attach_file,
                //           color: Colors.white54,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
              icon: isShowSendButton
                  ? const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.mic,
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
