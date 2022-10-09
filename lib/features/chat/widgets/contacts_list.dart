import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';
import 'package:my_chat/features/chat/controller/chat_controller.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/chat_contact.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:my_chat/features/chat/screens/mobile_chat_screen.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).chatContacts(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.done:
                {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        String locale =
                            Localizations.localeOf(context).languageCode;
                        var chatContactData = snapshot.data![index];

                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    MobileChatScreen.routeName,
                                    arguments: {
                                      'name': chatContactData.name,
                                      'uid': chatContactData.contactId
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ListTile(
                                  title: Text(
                                    chatContactData.name,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      chatContactData.lastMessage,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      chatContactData.profilePic,
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm()
                                        .format(chatContactData.timeSent),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(color: dividerColor, indent: 85),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(AppLocalizations.of(context).no_messages_yet),
                    );
                  }
                }
              default:
                return const LoaderScreen();
            }
          }),
    );
  }
}
