// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoContent extends StatefulWidget {
  final String source;
  const VideoContent({
    Key? key,
    required this.source,
  }) : super(key: key);

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  late final CachedVideoPlayerController _controller;
  bool isPlay = false;

  @override
  void initState() {
    _controller = CachedVideoPlayerController.network(widget.source)
      ..initialize().then((value) {
        _controller.setVolume(1);
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(_controller),
          Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  isPlay ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white54.withOpacity(0.5),
                  size: 50,
                ),
                onPressed: () {
                  if (isPlay) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  setState(() {
                    isPlay = !isPlay;
                  });
                },
              ))
        ],
      ),
    );
  }
}
