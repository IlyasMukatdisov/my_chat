import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';
import 'package:my_chat/features/status/controller/status_controller.dart';
import 'package:my_chat/features/status/screens/status_screen.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/status_model.dart';
import 'package:my_chat/utils/app_constants.dart';
import 'package:my_chat/utils/colors.dart';

class StatusContactsScreen extends ConsumerStatefulWidget {
  const StatusContactsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StatusContactsScreenState();
}

class _StatusContactsScreenState extends ConsumerState<StatusContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context: context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: Padding(
                padding:
                    const EdgeInsets.only(top: AppConstants.defaultPadding),
                child: snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var statusData = snapshot.data![index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    StatusScreen.routeName,
                                    arguments: statusData,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ListTile(
                                    title: Text(
                                      statusData.username,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        statusData.profilePic,
                                      ),
                                      radius: 30,
                                    ),
                                  ),
                                ),
                              ),
                              const Divider(color: dividerColor, indent: 85),
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Text(AppLocalizations.of(context).no_statuses),
                      ),
              ),
            );

          default:
            return const LoaderScreen();
        }
      },
    );
  }
}
