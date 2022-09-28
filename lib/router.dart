import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/common/widgets/error_screen.dart';
import 'package:my_chat/features/auth/screens/login_screen.dart';
import 'package:my_chat/features/auth/screens/otp_screen.dart';
import 'package:my_chat/features/auth/screens/user_info_screen.dart';

import 'package:my_chat/generated/l10n.dart';

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
        builder: (context) => UserInfoScreen(),
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
