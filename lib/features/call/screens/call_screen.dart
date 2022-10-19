// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';
import 'package:my_chat/config/agora_config.dart';
import 'package:my_chat/features/call/controller/call_controller.dart';

import 'package:my_chat/models/call.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final CallModel call;
  final bool isGroupChat;

  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? _client;
  String baseUrl = 'https://my-chat-token-server.herokuapp.com/';

  @override
  void initState() {
    super.initState();
    _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  @override
  Widget build(BuildContext context) {
    return _client == null
        ? const LoaderScreen()
        : Scaffold(
            body: WillPopScope(
              onWillPop: () async {
                endCall();
                return true;
              },
              child: SafeArea(
                child: Stack(
                  children: [
                    AgoraVideoViewer(client: _client!),
                    AgoraVideoButtons(
                      client: _client!,
                      disconnectButtonChild: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.redAccent,
                        ),
                        child: IconButton(
                          onPressed: () {
                            endCall();
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void endCall() async {
    await _client!.engine.leaveChannel();
    ref.read(callControllerProvider).endCall(
          callerId: widget.call.callerId,
          receiverId: widget.call.receiverId,
          context: context,
        );
  }

  void initAgora() async {
    await _client!.initialize();
  }
}
