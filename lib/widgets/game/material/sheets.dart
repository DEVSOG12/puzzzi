// import 'dart:io';
// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:puzzzi/config/ui.dart';
import 'package:puzzzi/data/board.dart';
// import 'package:puzzzi/utils/platform.dart';
import 'package:puzzzi/widgets/about/dialog.dart';
// import 'package:puzzzi/widgets/donate/dialog.dart';
import 'package:puzzzi/widgets/game/board.dart';
import 'package:puzzzi/widgets/game/material/page.dart';
import 'package:flutter/material.dart' hide AboutDialog;

import '../page.dart';
// import 'package:flutter/widgets.dart';

Widget createMoreBottomSheet(
  BuildContext context,
  bool mode, {
  required Function(int?) call,
}) {
  final config = ConfigUiContainer.of(context);

  Widget createBoard({int? size}) => Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black12,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Semantics(
                label: '${size}x$size',
                child: InkWell(
                  onTap: () {
                    call(size);
                    Navigator.of(context).pop();
                  },
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final puzzleSize = min(
                        min(
                          constraints.maxWidth,
                          constraints.maxHeight,
                        ),
                        96.0,
                      );

                      return Semantics(
                        excludeSemantics: true,
                        child: BoardWidget(
                          mode: false,
                          level: 0,
                          board: Board.createNormal(size!),
                          onTap: null,
                          showNumbers: false,
                          size: puzzleSize,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Semantics(
              excludeSemantics: true,
              child: Align(
                alignment: Alignment.center,
                child: Text('${size}x$size'),
              ),
            ),
          ],
        ),
      );

  final items = <Widget>[
    const SizedBox(height: 16),
    Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(
            Icons.info_outline,
            semanticLabel: "Info",
          ),
          onPressed: () {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (context) {
                  return const AboutDialog();
                });
          },
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: OutlineButton(
              color: Colors.lightBlue,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    // ignore: unnecessary_const
                    const BorderRadius.all(const Radius.circular(16.0)),
              ),
              onPressed: () {
                if (!mode && FirebaseAuth.instance.currentUser == null) {
                  Fluttertoast.showToast(
                      msg: "You cannot change mode except you are logged in");
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Intro(
                              islogged:
                                  FirebaseAuth.instance.currentUser != null,
                              mode: !mode)));
                  mode = !mode;
                }
              },
              child: Text(mode ? "Level Mode" : "Free Mode"),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: OutlineButton(
              shape: const RoundedRectangleBorder(
                borderRadius:
                    // ignore: unnecessary_const
                    const BorderRadius.all(const Radius.circular(16.0)),
              ),
              onPressed: () {
                // Cycle themes like this:
                // Auto -> Dark -> Light -> Auto ...
                bool? shouldUseDarkTheme;
                if (config.useDarkTheme == null) {
                  shouldUseDarkTheme = true;
                } else if (config.useDarkTheme == true) {
                  shouldUseDarkTheme = false;
                } else {
                  shouldUseDarkTheme = null;
                }
                config.setUseDarkTheme(shouldUseDarkTheme, save: true);
              },
              child: Text(config.useDarkTheme == null
                  ? 'System theme'
                  : config.useDarkTheme == true
                      ? 'Dark theme'
                      : 'Light theme'),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    ),
    const SizedBox(height: 4),
    Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        "What size do you want to play?",
        style: TextStyle(fontSize: 28),
      ),
    ),
    const SizedBox(height: 4),
    Row(
      children: <Widget>[
        const SizedBox(width: 8),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: createBoard(size: 3),
          ),
        ),
        Expanded(child: createBoard(size: 4)),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: createBoard(size: 5),
          ),
        ),
        const SizedBox(width: 8),
      ],
    ),
    const SizedBox(height: 16),
    CheckboxListTile(
      dense: true,
      title: const Text('Speed run mode'),
      secondary: const Icon(Icons.timer),
      // subtitle: const Text('Reduce animations and switch controls to taps'),
      value: config.isSpeedRunModeEnabled,
      onChanged: (bool? value) {
        var shouldEnableSpeedRun = !config.isSpeedRunModeEnabled!;
        config.setSpeedRunModeEnabled(shouldEnableSpeedRun, save: true);
      },
    ),
  ];

  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = min(
          constraints.maxWidth,
          GameMaterialPage.kMaxBoardSize,
        );

        return Column(
          children: [
            SizedBox(
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items,
              ),
            ),
          ],
        );
      },
    ),
  );
}
