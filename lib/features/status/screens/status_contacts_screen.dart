import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';
import 'package:my_chat/features/status/controller/status_controller.dart';
import 'package:my_chat/models/status_model.dart';
import 'package:my_chat/utils/colors.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getStatus(context: context),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var statusData = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            statusData.username,
                            style: const TextStyle(
                                fontSize: 18, overflow: TextOverflow.ellipsis),
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
            );

          default:
            return const LoaderScreen();
        }
      },
    );
  }
}
