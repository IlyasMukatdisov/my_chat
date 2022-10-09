import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';
import 'package:my_chat/features/chat/controller/chat_controller.dart';
import 'package:my_chat/features/chat/widgets/my_message_card.dart';
import 'package:my_chat/features/chat/widgets/sender_message_card.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/message.dart';
import 'package:my_chat/utils/app_constants.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;

  const ChatList({Key? key, required this.receiverUserId}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream:
            ref.watch(chatControllerProvider).chatStream(widget.receiverUserId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                String splitDate = DateFormat()
                    .add_yMd()
                    .format(snapshot.data!.first.timeSent);
                bool shouldShowDate;

                String tempDate;

                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });

                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        shouldShowDate = true;
                        tempDate = splitDate;
                      } else {
                        shouldShowDate = false;
                        tempDate = DateFormat()
                            .add_yMd()
                            .format(snapshot.data![index].timeSent);
                        if (splitDate != tempDate) {
                          shouldShowDate = true;
                          splitDate = tempDate;
                        }
                      }

                      final message = snapshot.data![index];
                      final date = DateFormat.Hm().format(message.timeSent);
                      if (message.senderId != widget.receiverUserId) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: AppConstants.defaultPadding / 2),
                          child: Column(
                            children: [
                              shouldShowDate ? Text(splitDate) : Container(),
                              MyMessageCard(
                                message: message.text,
                                date: date,
                                type: message.type,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: AppConstants.defaultPadding / 2),
                          child: Column(
                            children: [
                              shouldShowDate ? Text(splitDate) : Container(),
                              SenderMessageCard(
                                message: message.text,
                                date: date,
                                type: message.type,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text(AppLocalizations.of(context).no_messages_yet),
                );
              }
            default:
              return const LoaderScreen();
          }
        });
  }
}