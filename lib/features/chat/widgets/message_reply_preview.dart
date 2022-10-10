import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/provider/message_reply_provider.dart';
import 'package:my_chat/features/chat/widgets/message_content.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/utils/app_constants.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding / 2),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.reply),
              const SizedBox(
                width: AppConstants.defaultPadding,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageReply!.replyMessageOwner,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    MessageContent(
                        isReplyPreview: true,
                        message: messageReply.message,
                        type: messageReply.messageType),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => cancelReply(ref),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
