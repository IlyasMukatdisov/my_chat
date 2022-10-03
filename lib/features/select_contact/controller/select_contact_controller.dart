// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_chat/features/select_contact/repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider(
  (ref) {
    final selectContactRepository = ref.watch(selectContactRepositoryProvider);
    return selectContactRepository.getContacts();
  },
);

final selectContactControllerProvider = Provider(
  (ref) {
    final SelectContactRepository repository =
        ref.watch(selectContactRepositoryProvider);
    return SelectContactController(
        ref: ref, selectContactRepository: repository);
  },
);

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;
  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact({
    required Contact selectedContact,
    required BuildContext context,
    required voidNavigationContactCallback onFound,
    required VoidCallback onNotFound,
  }) {
    selectContactRepository.selectContact(
      selectedContact: selectedContact,
      context: context,
      onFound: onFound,
      onNotFound: onNotFound,
    );
  }
}
