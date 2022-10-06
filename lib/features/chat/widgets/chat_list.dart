import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';
import 'package:my_chat/features/chat/controller/chat_controller.dart';
import 'package:my_chat/info.dart';
import 'package:my_chat/models/message.dart';
import 'package:my_chat/widgets/my_message_card.dart';
import 'package:my_chat/widgets/sender_message_card.dart';

class ChatList extends ConsumerWidget {
  final String receiverUserId;

  const ChatList({Key? key, required this.receiverUserId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref)  {
    return StreamBuilder<List<Message>>(
        stream: ref.watch(chatControllerProvider).chatStream(receiverUserId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index)  {
                    if (snapshot.data![index].senderId == ) {
                      return MyMessageCard(
                        message: messages[index]['text'].toString(),
                        date: messages[index]['time'].toString(),
                      );
                    }
                    return SenderMessageCard(
                      message: messages[index]['text'].toString(),
                      date: messages[index]['time'].toString(),
                    );
                  },
                );
              } else {
                return LoaderScreen();
              }
            default:
              return LoaderScreen();
          }
        });
  }

 
}
