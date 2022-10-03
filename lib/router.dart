import 'package:flutter/material.dart';
import 'package:my_chat/common/widgets/error_screen.dart';
import 'package:my_chat/features/auth/screens/login_screen.dart';
import 'package:my_chat/features/auth/screens/otp_screen.dart';
import 'package:my_chat/features/auth/screens/user_info_screen.dart';
import 'package:my_chat/features/select_contact/screens/select_contact_screen.dart';

import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/screens/mobile_chat_screen.dart';
import 'package:my_chat/screens/mobile_layout_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OtpScreen.routeName:
      {
        final verificationId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => OtpScreen(verificationId: verificationId),
        );
      }
    case UserInfoScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileLayoutScreen(),
      );
    case SelectContactsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactsScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(name: name, uid: uid),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: ErrorScreen(
              errorMessage: AppLocalizations.of(context).page_does_not_exists),
        ),
      );
  }
}
