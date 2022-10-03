import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/user_model.dart';
import 'package:my_chat/utils/app_constants.dart';

typedef voidNavigationContactCallback = void Function(UserModel user);

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  final FirebaseFirestore firestore;
  SelectContactRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withPhoto: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact({
    required Contact selectedContact,
    required BuildContext context,
    required voidNavigationContactCallback onFound,
    required VoidCallback onNotFound,
  }) async {
    try {
      bool isFound = false;
      var userCollection =
          await firestore.collection(AppConstants.usersCollection).get();

      for (var doc in userCollection.docs) {
        var userData = UserModel.fromMap(doc.data());
        if (userData.phoneNumber ==
                selectedContact.phones.first.normalizedNumber
                    .replaceAll(' ', '') ||
            userData.phoneNumber ==
                selectedContact.phones.first.number.replaceAll(' ', '')) {
          isFound = true;
          onFound(userData);
        }
      }

      if (!isFound) {
        onNotFound();
      }
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }
}
