// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:my_chat/common/enums/message_enum.dart';
import 'package:my_chat/features/chat/widgets/video_content.dart';

class MessageContent extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool isReplyPreview;
  bool? isGroupChat;
  String? name;

  final AudioPlayer audioPlayer = AudioPlayer();

  MessageContent({
    Key? key,
    required this.message,
    required this.type,
    this.isReplyPreview = false,
    this.isGroupChat,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    switch (type) {
      case MessageEnum.text:
        return Column(
          children: [
            isGroupChat != null ? Text(name ?? 'sender') : const SizedBox(),
            isGroupChat != null
                ? const SizedBox(
                    height: 5,
                  )
                : const SizedBox(),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        );
      case MessageEnum.audio:
        {
          return StatefulBuilder(
            builder: (context, setState) {
              audioPlayer.onPlayerComplete.listen((event) {
                setState(() {
                  isPlaying = false;
                });
              });

              return Column(
                children: [
                  isGroupChat != null
                      ? Text(name ?? 'sender')
                      : const SizedBox(),
                  isGroupChat != null
                      ? const SizedBox(
                          height: 5,
                        )
                      : const SizedBox(),
                  Container(
                    width: 80,
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          if (await audioPlayer.getCurrentPosition() ==
                              const Duration(seconds: 0)) {
                            await audioPlayer.play(UrlSource(message));
                          } else {
                            await audioPlayer.resume();
                          }

                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                      icon: Icon(
                          isPlaying ? Icons.stop_circle : Icons.play_circle,
                          size: 40),
                    ),
                  ),
                ],
              );
            },
          );
        }
      case MessageEnum.image:
        return Column(
          children: [
            isGroupChat != null ? Text(name ?? 'sender') : const SizedBox(),
            isGroupChat != null
                ? const SizedBox(
                    height: 5,
                  )
                : const SizedBox(),
            CachedNetworkImage(
              imageUrl: message,
              height: isReplyPreview ? 40 : null,
            ),
          ],
        );
      case MessageEnum.video:
        return Column(
          children: [
            isGroupChat != null ? Text(name ?? 'sender') : const SizedBox(),
            isGroupChat != null
                ? const SizedBox(
                    height: 5,
                  )
                : const SizedBox(),
            VideoContent(source: message, isReplyPreview: isReplyPreview),
          ],
        );

      default:
        return Container();
    }
  }
}
