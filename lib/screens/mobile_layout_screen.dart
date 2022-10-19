import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/utils/utils.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';
import 'package:my_chat/features/group/screens/create_group_screen.dart';
import 'package:my_chat/features/select_contact/screens/select_contact_screen.dart';
import 'package:my_chat/features/status/screens/confirm_status_screen.dart';
import 'package:my_chat/features/status/screens/status_contacts_screen.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:my_chat/features/chat/widgets/contacts_list.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  static const routeName = '/mobile-layout-screen';
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final TabController _tabController;
  int index = 0;

  @override
  void initState() {
    ref.read(authControllerProvider).setUserState(true);
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      default:
        ref.read(authControllerProvider).setUserState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      minLeadingWidth: 35,
                      title: Text(
                        AppLocalizations.of(context).create_group,
                        style: const TextStyle(fontSize: 16),
                      ),
                      leading: const Icon(Icons.group),
                      onTap: () => Future(
                        () => Navigator.of(context)
                            .pushNamed(CreateGroupScreen.routeName),
                      ),
                    ),
                  )
                ];
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
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
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ContactsList(),
            StatusContactsScreen(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            switch (_tabController.index) {
              case 0:
                {
                  Navigator.of(context)
                      .pushNamed(SelectContactsScreen.routeName);
                  break;
                }
              case 1:
                {
                  File? pickedImage = await pickImageFromGallery(context);
                  if (pickedImage != null) {
                    _navigate(ConfirmStatusScreen.routeName, pickedImage);
                  }
                  break;
                }
              default:
                break;
            }
          },
          backgroundColor: tabColor,
          child: Icon(
            index == 0
                ? Icons.comment
                : index == 1
                    ? Icons.add_a_photo
                    : Icons.error,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigate(String routeName, Object? arguments) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }
}
