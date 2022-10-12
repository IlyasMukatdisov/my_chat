// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';

import 'package:my_chat/models/status_model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;
  const StatusScreen({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  late final StoryController _storyController;
  List<StoryItem> stories = [];
  @override
  void initState() {
    _storyController = StoryController();
    _initStoryPageItems();
    super.initState();
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: stories.isEmpty
            ? const LoaderScreen()
            : StoryView(
                storyItems: stories,
                controller: _storyController,
                onVerticalSwipeComplete: (position) {
                  if (position == Direction.down) {
                    Navigator.pop(context);
                  }
                },
              ));
  }

  void _initStoryPageItems() {
    for (var photoUrl in widget.status.photoUrl) {
      stories.add(
          StoryItem.pageImage(url: photoUrl, controller: _storyController));
    }
  }
}
