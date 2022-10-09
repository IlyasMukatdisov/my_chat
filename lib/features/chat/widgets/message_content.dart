// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:my_chat/common/enums/message_enum.dart';
import 'package:my_chat/features/chat/widgets/video_content.dart';

class MessageContent extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const MessageContent({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    switch (type) {
      case MessageEnum.text:
        return Text(
          message,
          style: const TextStyle(fontSize: 16),
        );
      case MessageEnum.audio:
        {
          return StatefulBuilder(
            builder: (context, setState) {
              final AudioPlayer audioPlayer = AudioPlayer();
              audioPlayer.onPlayerComplete.listen((event) {
                setState(() {
                  isPlaying = false;
                });
              });

              return Container(
                width: 80,
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.stop();
                      setState(() {
                        isPlaying = false;
                      });
                    } else {
                      setState(() {
                        isPlaying = true;
                      });
                      await audioPlayer.play(UrlSource(message));
                    }
                  },
                  icon: Icon(isPlaying ? Icons.stop_circle : Icons.play_circle,
                      size: 40),
                ),
              );
            },
          );
        }
      case MessageEnum.image:
        return CachedNetworkImage(
          imageUrl: message,
        );
      case MessageEnum.video:
        return VideoContent(
          source: message,
        );

      default:
        return Container();
    }
  }
}