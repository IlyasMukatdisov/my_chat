// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:my_chat/common/enums/message_enum.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/chat/controller/chat_controller.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/utils/app_constants.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool isRecorderInit = false;
  bool isRecording = false;
  late final FlutterSoundRecorder _flutterSoundRecorder;
  late final TextEditingController _messageController;

  @override
  void initState() {
    _messageController = TextEditingController();
    _flutterSoundRecorder = FlutterSoundRecorder();
    openAudio();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _flutterSoundRecorder.closeRecorder();
    super.dispose();
    isRecorderInit = false;
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException(
          AppLocalizations.current.mic_permission_not_granted);
    }
    await _flutterSoundRecorder.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() {
    if (!isTextEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text.trim(),
            receiverUserId: widget.receiverUserId,
          );
      _messageController.clear();
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum fileType,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
        context: context,
        file: file,
        receiverUserId: widget.receiverUserId,
        fileType: fileType);
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void sendAudioMessage() async {
    var tempDir = await getTemporaryDirectory();
    var path = '${tempDir.path}/flutter_sound.aac';
    if (!isRecorderInit) {
      return;
    }
    if (isRecording) {
      await _flutterSoundRecorder.stopRecorder();
      sendFileMessage(File(path), MessageEnum.audio);
    } else {
      await _flutterSoundRecorder.startRecorder(toFile: path);
    }

    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    isDense: false,
                    suffixIcon: isTextEmpty
                        ? Container(
                            width: 90,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: selectImage,
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white54,
                                  ),
                                ),
                                InkWell(
                                  onTap: selectVideo,
                                  child: const Icon(
                                    Icons.video_collection,
                                    color: Colors.white54,
                                  ),
                                )
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
                    } else
                      sendAudioMessage();
                  },
                  child: Icon(
                    isTextEmpty
                        ? (isRecording ? Icons.close : Icons.mic)
                        : Icons.send_rounded,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
