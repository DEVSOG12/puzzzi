// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:puzzzi/config/ui.dart';
// import 'package:puzzzi/play_games.dart';
import 'package:puzzzi/utils/platform.dart';
// import 'package:puzzzi/widgets/LoginP.dart';
import 'package:puzzzi/widgets/game/page.dart';
// import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzzi/widgets/src/signin.dart';
import 'package:puzzzi/widgets/src/signup.dart';
// import 'package:puzzzi/widgets/login_page.dart';
// import 'package:puzzzi/widgets/signup.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this

  FirebaseApp defaultApp = await Firebase.initializeApp();
  log(defaultApp.name);
  _setTargetPlatformForDesktop();

  runApp(
    const ConfigUiContainer(
      child: MyApp(),
    ),
  );
}

/// If the current platform is desktop, override the default platform to
/// a supported platform (iOS for macOS, Android for Linux and Windows).
/// Otherwise, do nothing.
void _setTargetPlatformForDesktop() {
  TargetPlatform? targetPlatform;
  if (platformCheck(() => Platform.isMacOS)) {
    targetPlatform = TargetPlatform.iOS;
  } else if (platformCheck(() => Platform.isLinux || Platform.isWindows)) {
    targetPlatform = TargetPlatform.android;
  }
  if (targetPlatform != null) {
    debugDefaultTargetPlatformOverride = targetPlatform;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Puzzzi';
    return const _MyMaterialApp(title: title);
  }
}

/// Base class for all platforms, such as
/// [Platform.isIOS] or [Platform.isAndroid].
abstract class _MyPlatformApp extends StatelessWidget {
  final String title;

  const _MyPlatformApp({required this.title});
}

class _MyMaterialApp extends _MyPlatformApp {
  const _MyMaterialApp({required String title}) : super(title: title);

  @override
  Widget build(BuildContext context) {
    bool islogged = FirebaseAuth.instance.currentUser != null;
    final ui = ConfigUiContainer.of(context);

    ThemeData applyDecor(ThemeData theme) => theme.copyWith(
          primaryColor: Colors.blue,
          accentIconTheme: theme.iconTheme.copyWith(color: Colors.black),
          dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
          textTheme: theme.textTheme.apply(fontFamily: 'Inconsolata'),
          primaryTextTheme:
              theme.primaryTextTheme.apply(fontFamily: 'Inconsolata'),
          accentTextTheme:
              theme.accentTextTheme.apply(fontFamily: 'Inconsolata'),
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.lightBlue),
        );

    final baseDarkTheme = applyDecor(ThemeData(
      brightness: Brightness.dark,
      canvasColor: const Color(0xFF121212),
      backgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
    ));
    final baseLightTheme = applyDecor(ThemeData.light());

    ThemeData darkTheme;
    ThemeData lightTheme;
    if (ui.useDarkTheme == null) {
      // auto
      darkTheme = baseDarkTheme;
      lightTheme = baseLightTheme;
    } else if (ui.useDarkTheme == true) {
      // dark
      darkTheme = baseDarkTheme;
      lightTheme = baseDarkTheme;
    } else {
      // light
      darkTheme = baseLightTheme;
      lightTheme = baseLightTheme;
    }

    return MaterialApp(
      title: title,
      darkTheme: darkTheme,
      theme: lightTheme,
      home: Builder(
        builder: (context) {
          bool? useDarkTheme;
          if (ui.useDarkTheme == null) {
            var platformBrightness = MediaQuery.of(context).platformBrightness;
            useDarkTheme = platformBrightness == Brightness.dark;
          } else {
            useDarkTheme = ui.useDarkTheme;
          }
          final overlay = useDarkTheme!
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark;
          SystemChrome.setSystemUIOverlayStyle(
            overlay.copyWith(
              statusBarColor: Colors.transparent,
            ),
          );

          return FirebaseAuth.instance.currentUser != null
              ? GamePage(
                  islogged: islogged,
                )
              : GamePage(islogged: islogged);
          // return GamePage();
        },
      ),
    );
  }
}

// class _MyCupertinoApp extends _MyPlatformApp {
//   _MyCupertinoApp({required String title}) : super(title: title);

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoApp(
//       title: title,
//     );
//   }
// }
