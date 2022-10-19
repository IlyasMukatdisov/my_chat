// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_chat/features/auth/controller/auth_controller.dart';
import 'package:my_chat/features/call/controller/call_controller.dart';
import 'package:my_chat/features/chat/widgets/bottom_chat_field.dart';
import 'package:my_chat/features/chat/widgets/chat_list.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/utils/colors.dart';

class MobileChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  static const routeName = '/mobile-chat-screen';
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePic,
  }) : super(key: key);

  void createCall(WidgetRef ref, BuildContext context) async {
    ref.read(callControllerProvider).createCall(
        receiverUserName: name,
        context: context,
        receiverUid: uid,
        receiverProfilePic: profilePic,
        isGroupChat: isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
                stream: ref.read(authControllerProvider).userData(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data!.isOnline
                              ? AppLocalizations.of(context).online
                              : AppLocalizations.of(context).offline,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                      ],
                    );
                  }
                  return Container();
                }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => createCall(ref, context),
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(receiverUserId: uid, isGroupChat: isGroupChat),
          ),
          BottomChatField(
            receiverUserId: uid,
            iSGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}
