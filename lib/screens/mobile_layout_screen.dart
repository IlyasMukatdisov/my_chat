import 'package:flutter/material.dart';
import 'package:my_chat/features/select_contact/screens/select_contact_screen.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:my_chat/features/chat/widgets/contacts_list.dart';

class MobileLayoutScreen extends StatelessWidget {
  static const routeName = '/mobile-layout-screen';
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            'My Chat',
            style: TextStyle(
              fontSize: 20,
              color: tabColor,
              // fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: AppLocalizations.of(context).chats.toUpperCase(),
              ),
              Tab(
                text: AppLocalizations.of(context).status.toUpperCase(),
              ),
              Tab(
                text: AppLocalizations.of(context).calls.toUpperCase(),
              ),
            ],
          ),
        ),
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SelectContactsScreen.routeName);
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
