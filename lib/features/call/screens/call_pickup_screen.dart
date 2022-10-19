import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/call/controller/call_controller.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/models/call.dart';
import 'package:my_chat/utils/app_constants.dart';

class CallPickUpScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickUpScreen({
    super.key,
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
        stream: ref.read(callControllerProvider).callStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            CallModel call = CallModel.fromMap(
                snapshot.data!.data() as Map<String, dynamic>);
            if (!call.hasDialed) {
              return Scaffold(
                body: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).incoming_call,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(call.callerPic),
                        radius: 60,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        call.callerName,
                        style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.call_end,
                                color: Colors.redAccent,
                                size: 40,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.call,
                                color: Colors.greenAccent,
                                size: 40,
                              ),
                            ),
                          ])
                    ],
                  ),
                ),
              );
            }
          }
          return scaffold;
        });
  }
}
