import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/widgets/error_screen.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';
import 'package:my_chat/features/select_contact/controller/select_contact_controller.dart';
import 'package:my_chat/generated/l10n.dart';

final selectedGroupContactsProvider = StateProvider<List<Contact>>(
  (ref) => [],
);

class SelectContactGroup extends ConsumerStatefulWidget {
  const SelectContactGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactGroupState();
}

class _SelectContactGroupState extends ConsumerState<SelectContactGroup> {
  List<int> selectedContactIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactIndex.contains(index)) {
      selectedContactIndex.remove(index);
    } else {
      selectedContactIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContactsProvider.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
          data: (contactList) => Expanded(
            child: ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectContact(index, contact),
                  child: ListTile(
                    leading: selectedContactIndex.contains(index)
                        ? IconButton(
                            icon: const Icon(Icons.done),
                            onPressed: () {},
                          )
                        : null,
                    title: Text(contact.displayName),
                    subtitle: Text(
                      contact.phones.isNotEmpty
                          ? (contact.phones.first.normalizedNumber.isEmpty
                              ? contact.phones.first.number
                              : contact.phones.first.normalizedNumber)
                          : '',
                    ),
                  ),
                );
              },
            ),
          ),
          error: (error, stackTrace) => ErrorScreen(
              errorMessage: AppLocalizations.of(context).cant_load_data),
          loading: () => const LoaderScreen(),
        );
  }
}
