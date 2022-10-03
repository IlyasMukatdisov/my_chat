import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/common/widgets/error_screen.dart';
import 'package:my_chat/common/widgets/loader_screen.dart';
import 'package:my_chat/features/auth/controller/auth_controller.dart';
import 'package:my_chat/features/select_contact/screens/select_contact_screen.dart';
import 'package:my_chat/generated/l10n.dart';
import 'package:my_chat/router.dart';
import 'package:my_chat/utils/colors.dart';
import 'package:my_chat/features/landing/screens/landing_screen.dart';
import 'package:my_chat/firebase_options.dart';
import 'package:my_chat/screens/mobile_layout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        colorScheme: ThemeData.dark()
            .colorScheme
            .copyWith(secondary: tabColor, primary: tabColor),
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (error, stackTrace) {
              return ErrorScreen(
                errorMessage: error.toString(),
              );
            },
            loading: () => const LoaderScreen(),
          ),
    );
  }
}
