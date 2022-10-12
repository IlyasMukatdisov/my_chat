import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';
import 'package:my_chat/features/auth/screens/user_info_screen.dart';
import 'package:my_chat/features/chat/screens/mobile_chat_screen.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/screens/mobile_layout_screen.dart';
import 'package:my_chat/utils/app_constants.dart';

class OtpScreen extends ConsumerWidget {
  static const routeName = "/otp-screen";
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  void verifyOTP(
      {required WidgetRef ref,
      required BuildContext context,
      required String value}) {
    ref.read(authControllerProvider).verifyOTP(
          context: context,
          verificationId: verificationId,
          userOTP: value,
          onSuccess: () async {
            var currentUser =
                await ref.read(authControllerProvider).getCurrentUserData();
            if (currentUser!.name.isNotEmpty &&
                currentUser.profilePic.isNotEmpty) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                MobileLayoutScreen.routeName,
                (route) => false,
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                UserInfoScreen.routeName,
                (route) => false,
              );
            }
          },
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).verify_your_number),
      ),
      body: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        width: size.width,
        child: Column(
          children: [
            Text(AppLocalizations.of(context).we_have_send_sms),
            const SizedBox(
              height: AppConstants.defaultPadding * 2,
            ),
            SizedBox(
              width: size.width / 2,
              child: TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 5,
                ),
                decoration: const InputDecoration(
                    hintText: '- - - - - -',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(fontSize: 24)),
                maxLength: 6,
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyOTP(
                      ref: ref,
                      context: context,
                      value: value.trim(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
