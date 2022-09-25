import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:my_chat/features/landing/screens/landing_screen.dart';
import 'package:my_chat/firebase_options.dart';
import 'package:my_chat/screens/mobile_layout_screen.dart';
import 'package:my_chat/screens/web_layout_screen.dart';
import 'package:my_chat/utils/responsive_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: 'My Chat',
        theme: ThemeData.dark().copyWith(
          colorScheme:
              ThemeData.dark().colorScheme.copyWith(secondary: tabColor),
          scaffoldBackgroundColor: backgroundColor,
        ),
        home: const LandingScreen()
        // ResponsiveLayout(
        //   mobileScreenLayout: MobileLayoutScreen(),
        //   webScreenLayout: WebLayoutScreen(),
        // ),
        );
  }
}
