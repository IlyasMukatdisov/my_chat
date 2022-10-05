import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';
import 'package:my_chat/features/chat/widgets/bottom_chat_field.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:my_chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  final String name;
  final String uid;
  static const routeName = '/mobile-chat-screen';
  const MobileChatScreen({
    Key? key,
    required this.name,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
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
            onPressed: () {},
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
          const Expanded(
            child: ChatList(),
          ),
          BottomChatField(receiverUserId: uid),
        ],
      ),
    );
  }
}

