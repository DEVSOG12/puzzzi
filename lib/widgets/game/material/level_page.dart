import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:puzzzi/config/ui.dart';
import 'package:puzzzi/widgets/auto_size_text.dart';
import 'package:puzzzi/widgets/game/board.dart';
import 'package:puzzzi/widgets/game/material/control.dart';
import 'package:puzzzi/widgets/game/material/display.dart';
import 'package:puzzzi/widgets/game/material/lead.dart';
// import 'package:puzzzi/widgets/game/material/leaderboard.dart';
import 'package:puzzzi/widgets/game/material/sheets.dart';
import 'package:puzzzi/widgets/game/material/steps.dart';
import 'package:puzzzi/widgets/game/material/stopwatch.dart';
// import 'package:puzzzi/widgets/game/material/victory.dart';
import 'package:puzzzi/widgets/game/presenter/main.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'package:puzzzi/widgets/icons/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:puzzzi/widgets/src/signin.dart';
import 'package:puzzzi/widgets/src/signup.dart';

int t = DateTime.now().millisecond;

class GameLevelMaterialPage extends StatefulWidget {
  /// Maximum size of the board,
  /// in pixels.
  bool? islogged;

  static const kMaxBoardSize = 400.0;

  static const kBoardMargin = 16.0;

  static const kBoardPadding = 4.0;
  bool show = false;

  GameLevelMaterialPage({Key? key, this.islogged}) : super(key: key);

  @override
  State<GameLevelMaterialPage> createState() => _GameLevelMaterialPageState();
}

class _GameLevelMaterialPageState extends State<GameLevelMaterialPage> {
  ConfettiController? controllerTopCenter;

  @override
  void initState() {
    super.initState();
    setState(() {
      initController();
    });
  }

  void initController() {
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  final FocusNode _boardFocus = FocusNode();
  int? levels;

  bool? mode;
  @override
  Widget build(BuildContext context) {
    // GamePresenterWidget.of(context).timereq = 5;
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
    Align buildConfettiWidget(controller, double blastDirection) {
      return Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          maximumSize: const Size(30, 30),
          shouldLoop: false,
          confettiController: controller,
          blastDirection: blastDirection,
          blastDirectionality: BlastDirectionality.directional,
          maxBlastForce: 20, // set a lower max blast force
          minBlastForce: 8, // set a lower min blast force
          emissionFrequency: 1,
          // minBlastForce: 8, // a lot of particles at once
          gravity: 1,
        ),
      );
    }

    final boardWidget = _buildBoard(context);

    return OrientationBuilder(builder: (context, orientation) {
      final user = FirebaseAuth.instance.currentUser;
      final now = DateTime.now().millisecondsSinceEpoch;
      int level = 1;
      // dev.log(presenter.time.toString());
      final statusWidget = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (user != null)
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  // print(

                  // );
                  if (snapshot.hasData) {
                    DocumentSnapshot snapshots =
                        snapshot.data as DocumentSnapshot;
                    Map<String, dynamic>? snap =
                        snapshots.data() as Map<String, dynamic>?;
                    // Map data = snapshots.data()! as Map;
                    level = snap!["level"];

                    levels = snap["level"];

                    return Column(
                      children: [
                        AutoSizeText(
                          "data",
                          "Level ${snap["level"]}",
                          minFontSize: 30,
                        ),
                      ],
                    );
                  }

                  return const Text("Shimmer");
                }),
          Visibility(
            visible: (widget.show && !presenter.show),
            child: GameLevelStopwatchWidget(
              whenTimeExpires: () {
                setState(() {
                  widget.show = false;
                });
                presenter.stop(false);
              },
              secondsRemaining:
                  (presenter.board!.size * 2) - (pow(level * 2, 0.2)).round(),

              time: pow(level * 2, 0.4).round().isNegative
                  ? ((presenter.board!.size * 2) - pow(level * 2, 0.4).round())
                          .isNegative
                      ? 0
                      : 1
                  : (presenter.board!.size * 2) - pow(level * 2, 0.4).round(),

              // : (presenter.board!.size * 2) - 2 * (level % 2),
              // time: (presenter.board!.size * 3) - level % 2,
              // time: 1,
              fontSize: orientation == Orientation.landscape && !isLargeScreen
                  ? 56
                  // : (presenter.isPlaying() &&
                  //         (orientation == Orientation.portrait))
                  //     ? 30
                  : 72.0,
            ),
          ),
          GameStepsWidget(
            steps: presenter.steps,
          ),
          const SizedBox(
            height: 10,
          ),
          // presenter.widget.or
          if (!(presenter.isPlaying() && (orientation == Orientation.portrait)))
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    DocumentSnapshot snapshots =
                        snapshot.data as DocumentSnapshot;
                    Map<String, dynamic>? snap =
                        snapshots.data() as Map<String, dynamic>?;
                    // Map data = snapshots.data()! as Map;
                    // FirebaseFirestore.instance
                    //     .collection("users")
                    //     .doc(user.uid)
                    //     .update({
                    //   "level": snap!["level"] + 1,
                    //   "xp": snap["max_xp"] < snap["xp"]
                    //       ? snap["xp"] - snap["max_xp"]
                    //       : 0,
                    //   "max_xp": (snap["level"] + 1) * 250
                    // });

                    if (((snap!["level"] % 10) == 0) && (snap["xp"] <= 100)) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .update({
                        // "level": snap["level"] + 1,
                        "xp": snap["level"] * 10,
                        // "max_xp": (snap["level"] + 1) * 250
                      });
                    }
                    if (snap["max_xp"] <= snap["xp"]) {
                      controllerTopCenter!.play();
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      "Congratulations!",
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text(
                                        "You have Leveled up! ",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.blue),
                                      ),
                                      Text(
                                        "You are in Level ${(snap["level"] + 1).toString()}",
                                        // const SizedBox(height: 16),
                                      ),
                                      if ((snap["level"] + 1) % 10 == 0 &&
                                          (snap["xp"] <= 100))
                                        Text(
                                            "You have earn ${(snap["level"] * 10) - snap["level"]} points"),
                                      if ([30, 50, 70, 90]
                                          .contains((snap["level"] as int)))
                                        const Text(
                                            "You have also unlocked a new Board!")
                                    ],

                                    // actions: actions,
                                  ));
                            });

                        // Add Your Code here.
                      });

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.uid)
                          .update({
                        "level": snap["level"] + 1,
                        "xp": snap["max_xp"] < snap["xp"]
                            ? snap["xp"] - snap["max_xp"]
                            : 0,
                        "max_xp": (snap["level"] + 1) * 250
                      });
                    }

                    return Column(
                      children: [
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width / 6,
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Stack(
                            children: [
                              
                              FAProgressBar(
                                animatedDuration: const Duration(seconds: 2),
                                progressColor:
                                    Colors.primaries[snap["level"] % 10],
                                // displayText:
                                //     "${snap["xp"]} XP/ ${snap["max_xp"]} XP",
                                // displayTextStyle: TextStyle(
                                //   color: Colors.black,
                                // ),
                                currentValue: ((snap["xp"] / snap["max_xp"]) *
                                        100 as double)
                                    .round(),
                              ),
                                Padding(
                                                            padding: const EdgeInsets.all(12.0),
child:
                              Text(
                                "${snap["xp"]} XP/ ${snap["max_xp"]} XP",
                                style: const TextStyle(color: Colors.black),
                              ),
                                  ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width / 12,
                        // ),
                      ],
                    );
                  }

                  return const Text("Shimmer");
                }),
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
                if (FirebaseAuth.instance.currentUser != null)
                  Row(
                    children: [
                      Text(
                        " Howdy,${user!.displayName} ",
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 29),
                      ),
                    ],
                  ),
                if (FirebaseAuth.instance.currentUser == null)
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.lightBlue),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SignUpPage()));
                            },
                            child: const Text("Sign Up Now",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ))
                    ],
                  ),
                isTallScreen
                    ? SizedBox(
                        height: 56,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => DisplayDialog(
                                            pres: presenter,
                                            level: levels,
                                          ));
                                },
                                child: AppIcon(
                                  size: 24.0,
                                  bsize: presenter.board!.size,
                                ),
                              ),
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
                buildConfettiWidget(controllerTopCenter, pi / 1),
                buildConfettiWidget(controllerTopCenter, pi / 4),
                Center(
                  child: statusWidget,
                ),
                const SizedBox(height: 16.0),
                buildConfettiWidget(controllerTopCenter, pi / 1),
                buildConfettiWidget(controllerTopCenter, pi / 4),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: boardWidget,
                  ),
                ),
                isLargeScreen && isTallScreen
                    ? const SizedBox(height: 116.0)
                    : const SizedBox(height: 72.0),
                buildConfettiWidget(controllerTopCenter, pi / 1),
                buildConfettiWidget(controllerTopCenter, pi / 4),
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
                if (FirebaseAuth.instance.currentUser != null)
                  Row(
                    children: [
                      Text(
                        " Howdy,${user!.displayName} ",
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 29),
                      ),
                    ],
                  ),
                if (FirebaseAuth.instance.currentUser == null)
                  Row(
                    children: [
                      Container(
                          alignment: Alignment.topLeft,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.lightBlue),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SignUpPage()));
                            },
                            child: const Text("Sign Up Now",
                                style: const TextStyle(
                                  color: Colors.white,
                                )),
                          ))
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
                buildConfettiWidget(controllerTopCenter, pi / 1),
                buildConfettiWidget(controllerTopCenter, pi / 4),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _ilead(final BuildContext context) {
    return IconButton(
        tooltip: "Leaderboard",
        onPressed: () {
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
        margin: const EdgeInsets.all(GameLevelMaterialPage.kBoardMargin),
        padding: const EdgeInsets.all(GameLevelMaterialPage.kBoardPadding),
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
              GameLevelMaterialPage.kMaxBoardSize -
                  (GameLevelMaterialPage.kBoardMargin +
                          GameLevelMaterialPage.kBoardPadding) *
                      2,
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
                level: levels,
                mode: true,
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
            child: IconButton(
              tooltip: "Start over",
              onPressed: () {
                presenter.reset();
              },
              // customBorder: const CircleBorder(),
              icon: const Icon(
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
            if (!presenter.isPlaying()) {
              setState(() {
                widget.show = true;
              });
            } else {
              setState(() {
                widget.show = false;
              });
            }
            presenter.playStop();
          },
        ),
        const SizedBox(width: 16.0),
        SizedBox(
          width: 48,
          height: 48,
          child: Material(
            elevation: 0.0,
            color: const Color(0x00000000),
            // shape: const CircleBorder(),
            child: IconButton(
              tooltip: "Settings",
              onPressed: () {
                // Show the modal bottom sheet on
                // tap on "More" icon.
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return createMoreBottomSheet(context, true, call: (size) {
                      presenter.resize(size);
                    });
                  },
                );
              },
              // customBorder: const CircleBorder(),
              icon: const Icon(
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
