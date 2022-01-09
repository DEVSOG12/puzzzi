import 'dart:math';

import 'package:puzzzi/config/ui.dart';
import 'package:puzzzi/widgets/game/board.dart';
import 'package:puzzzi/widgets/game/material/control.dart';
import 'package:puzzzi/widgets/game/material/lead.dart';
// import 'package:puzzzi/widgets/game/material/leaderboard.dart';
import 'package:puzzzi/widgets/game/material/sheets.dart';
import 'package:puzzzi/widgets/game/material/steps.dart';
import 'package:puzzzi/widgets/game/material/stopwatch.dart';
// import 'package:puzzzi/widgets/game/material/victory.dart';
import 'package:puzzzi/widgets/game/presenter/main.dart';
import 'package:puzzzi/widgets/icons/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';

class GameMaterialPage extends StatelessWidget {
  /// Maximum size of the board,
  /// in pixels.
  static const kMaxBoardSize = 400.0;

  static const kBoardMargin = 16.0;

  static const kBoardPadding = 4.0;

  final FocusNode _boardFocus = FocusNode();

  GameMaterialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = GamePresenterWidget.of(context);

    final screenSize = MediaQuery.of(context).size;
    final screenWidth =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? screenSize.width
            : screenSize.height;
    final screenHeight =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? screenSize.height
            : screenSize.width;

    final isTallScreen = screenHeight > 800 || screenHeight / screenWidth > 1.9;
    final isLargeScreen = screenWidth > 400;

    final fabWidget = _buildFab(context);
    final boardWidget = _buildBoard(context);
    return OrientationBuilder(builder: (context, orientation) {
      final statusWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GameStopwatchWidget(
            time: presenter.time,
            fontSize: orientation == Orientation.landscape && !isLargeScreen
                ? 56.0
                : 72.0,
          ),
          GameStepsWidget(
            steps: presenter.steps,
          ),
        ],
      );

      if (orientation == Orientation.portrait) {
        final user = FirebaseAuth.instance.currentUser;
        //
        // Portrait layout
        //
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    const Text(
                      "Howdy, ",
                      style: TextStyle(color: Colors.blue, fontSize: 29),
                    ),
                    Text( 
                      "${user!.displayName}",
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                          color: Colors.lightBlueAccent, fontSize: 35),
                    ),
                  ],
                ),
                isTallScreen
                    ? SizedBox(
                        height: 56,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const AppIcon(size: 24.0),
                              const SizedBox(width: 16.0),
                              Text(
                                'Puzzzi',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(height: 0),
                const SizedBox(height: 32.0),
                Center(
                  child: statusWidget,
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: boardWidget,
                  ),
                ),
                isLargeScreen && isTallScreen
                    ? const SizedBox(height: 116.0)
                    : const SizedBox(height: 72.0),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: fabWidget,
        );
      } else {
        final user = FirebaseAuth.instance.currentUser;

        //
        // Landscape layout
        //
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Howdy",
                      style: TextStyle(color: Colors.blue, fontSize: 29),
                    ),
                    Text(
                      "${user!.displayName}",
                      style: const TextStyle(
                          color: Colors.lightBlueAccent, fontSize: 35),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: boardWidget,
                      flex: 3,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          statusWidget,
                          const SizedBox(height: 48.0),
                          fabWidget,
                        ],
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _ilead(final BuildContext context) {
    return IconButton(
        onPressed: (){
            //  _showVictoryDialog() {
    showDialog(
      context: context,
      builder: (context) => const Lead(),
    );
  // }
        },
        icon: const Icon(Icons.leaderboard));
  }

  Widget _buildBoard(final BuildContext context) {
    final presenter = GamePresenterWidget.of(context);
    final config = ConfigUiContainer.of(context);
    final background = Theme.of(context).brightness == Brightness.dark
        ? Colors.black54
        : Colors.black12;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(kBoardMargin),
        padding: const EdgeInsets.all(kBoardPadding),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final puzzleSize = min(
              min(
                constraints.maxWidth,
                constraints.maxHeight,
              ),
              kMaxBoardSize - (kBoardMargin + kBoardPadding) * 2,
            );

            return RawKeyboardListener(
              autofocus: true,
              focusNode: _boardFocus,
              onKey: (event) {
                if (event is! RawKeyDownEvent) {
                  return;
                }

                int offsetY = 0;
                int offsetX = 0;
                switch (event.logicalKey.keyId) {
                  case 0x100070052: // arrow up
                    offsetY = 1;
                    break;
                  case 0x100070050: // arrow left
                    offsetX = 1;
                    break;
                  case 0x10007004f: // arrow right
                    offsetX = -1;
                    break;
                  case 0x100070051: // arrow down
                    offsetY = -1;
                    break;
                  default:
                    return;
                }
                final tapPoint =
                    presenter.board!.blank + Point(offsetX, offsetY);
                if (tapPoint.x < 0 ||
                    tapPoint.x >= presenter.board!.size ||
                    tapPoint.y < 0 ||
                    tapPoint.y >= presenter.board!.size) {
                  return;
                }

                presenter.tap(point: tapPoint);
              },
              child: BoardWidget(
                isSpeedRunModeEnabled: config.isSpeedRunModeEnabled,
                board: presenter.board,
                size: puzzleSize,
                onTap: (point) {
                  presenter.tap(point: point);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFab(final BuildContext context) {
    final presenter = GamePresenterWidget.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 48,
          height: 48,
          child: Material(
            elevation: 0.0,
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                presenter.reset();
              },
              customBorder: const CircleBorder(),
              child: const Icon(
                Icons.restore,
                semanticLabel: "Reset",
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        GamePlayStopButton(
          isPlaying: presenter.isPlaying(),
          onTap: () {
            presenter.playStop();
          },
        ),
        const SizedBox(width: 16.0),
        SizedBox(
          width: 48,
          height: 48,
          child: Material(
            elevation: 0.0,
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                // Show the modal bottom sheet on
                // tap on "More" icon.
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return createMoreBottomSheet(context, call: (size) {
                      presenter.resize(size);
                    });
                  },
                );
              },
              customBorder: const CircleBorder(),
              child: const Icon(
                Icons.settings,
                semanticLabel: "Settings",
              ),
            ),
          ),
        ),
        _ilead(context)
      ],
    );
  }
}
