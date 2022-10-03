import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/common/widgets/error_screen.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';
import 'package:my_chat/features/select_contact/controller/select_contact_controller.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/features/chat/screens/mobile_chat_screen.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const routeName = '/select-contact';
  const SelectContactsScreen({super.key});

  void selectContact({
    required WidgetRef ref,
    required BuildContext context,
    required Contact selectedContact,
  }) async {
    ref.read(selectContactControllerProvider).selectContact(
          selectedContact: selectedContact,
          context: context,
          onFound: (UserModel user) {
            Navigator.of(context).pushNamed(MobileChatScreen.routeName, arguments: {
              'name': user.name,
              'uid': user.uid
            });
          },
          onNotFound: () {
            showSnackBar(
                context: context,
                text: AppLocalizations.of(context).user_not_registered);
          },
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).select_contact),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ref.watch(getContactsProvider).when(
          data: (contactList) {
            return ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    selectContact(
                        ref: ref,
                        context: context,
                        selectedContact: contactList[index]);
                  },
                  child: ListTile(
                    leading: contactList[index].photo == null
                        ? null
                        : CircleAvatar(
                            backgroundImage:
                                MemoryImage(contactList[index].photo!),
                          ),
                    title: Text(contactList[index].displayName),
                    subtitle: Text(
                      contactList[index].phones.isNotEmpty
                          ? (contactList[index]
                                  .phones
                                  .first
                                  .normalizedNumber
                                  .isEmpty
                              ? contactList[index].phones.first.number
                              : contactList[index]
                                  .phones
                                  .first
                                  .normalizedNumber)
                          : '',
                    ),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) =>
              ErrorScreen(errorMessage: error.toString()),
          loading: () => const LoaderScreen()),
    );
  }
}
