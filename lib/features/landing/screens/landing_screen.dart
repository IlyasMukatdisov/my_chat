import 'package:flutter/material.dart';

import 'package:my_chat/common/widgets/custom_button.dart';
import 'package:my_chat/features/auth/screens/login_screen.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:my_chat/utils/app_constants.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text("${AppLocalizations.of(context).landing_title} My Chat",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: tabColor)),
                SizedBox(
                  height: size.height / 10,
                ),
                Image.asset(
                  "assets/bg.png",
                  color: tabColor,
                  width: size.width < 400 ? size.width : 400,
                ),
                SizedBox(
                  height: size.height / 10,
                ),
                Text(
                  AppLocalizations.of(context).landing_privacy_terms,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.white.withOpacity(0.7)),
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  width: size.width < 400 ? size.width : 400,
                  child: CustomButton(
                    text: AppLocalizations.of(context).agree_and_continue,
                    callback: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
