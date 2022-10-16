// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_chat/features/group/repository/group_repository.dart';

final groupControllerProvider = Provider(
  (ref) {
    final groupRepository = ref.read(groupRepositoryProvider);
    return GroupController(
      groupRepository: groupRepository,
      ref: ref,
    );
  },
);

class GroupController {
  final GroupRepository groupRepository;
  final ProviderRef ref;

  GroupController({
    required this.groupRepository,
    required this.ref,
  });

  void createGroup({
    required BuildContext context,
    required String name,
    required File profilePic,
    required List<Contact> selectedContacts,
  }) {
    groupRepository.createGroup(
        context: context,
        name: name,
        profilePic: profilePic,
        selectedContacts: selectedContacts);
  }
}
