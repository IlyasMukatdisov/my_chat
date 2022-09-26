import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_chat/features/auth/screens/login_screen.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/router.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:my_chat/features/landing/screens/landing_screen.dart';
import 'package:my_chat/firebase_options.dart';
import 'package:my_chat/screens/mobile_layout_screen.dart';
import 'package:my_chat/screens/web_layout_screen.dart';
import 'package:my_chat/utils/responsive_layout.dart';

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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        title: 'My Chat',
        onGenerateRoute: (settings) => generateRoute(settings),
        theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            color: backgroundColor,
            elevation: 0,
          ),
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
