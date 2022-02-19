import 'dart:math';

import 'package:puzzzi/data/result.dart';
import 'package:puzzzi/widgets/game/material/end.dart';
import 'package:puzzzi/widgets/game/material/level_page.dart';
// import 'package:puzzzi/play_games.dart';
import 'package:puzzzi/widgets/game/material/page.dart';
import 'package:puzzzi/widgets/game/material/victory.dart';
import 'package:puzzzi/widgets/game/presenter/main.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class Intro extends StatelessWidget {
  final bool? islogged;
  final bool? mode;

  const Intro({Key? key, this.islogged, this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rootWidget = _buildRoot(context);
    return GamePresenterWidget(
      child: rootWidget,
      onSolve: (result) {
        // _submitResult(context, result);
        _showVictoryDialog(context, result);
      },
      onEnd: (result) {
        _showEndDialog(context, result);
      },
    );
  }

  Widget _buildRoot(BuildContext context) {
    if (!mode!) {
      return GameLevelMaterialPage(
        islogged: islogged,
      );
    } else {
      return GameMaterialPage(
        islogged: islogged,
      );
    }
  }

  void _showVictoryDialog(BuildContext context, Result result) {
    showDialog(
      context: context,
      builder: (context) => GameVictoryDialog(
        result: result,
        islogged: islogged,
      ),
    );
  }

  void _showEndDialog(BuildContext context, Result result) {
    showDialog(
      context: context,
      builder: (context) => GameEndDialog(
        result: result,
        islogged: islogged,
      ),
    );
  }

  // void _submitResult(BuildContext context, Result result) {
  //   final playGames = PlayGamesContainer.of(context);
  //   playGames.submitScore(
  //     key: PlayGames.getLeaderboardOfSize(result.size),
  //     time: result.time,
  //   );
  // }
}

class GamePage extends StatefulWidget {
  final bool? islogged;
  const GamePage({Key? key, this.islogged}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Widget createBoard({int? size, context, label, mode}) => Center(
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
                label: label,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => Intro(
                                  islogged: widget.islogged,
                                  mode: mode == 0 ? true : false,
                                )));
                    // Navigator.of(context).pop();
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
                        child: Container(
                            height: 160,
                            width: 160,
                            child: Image.asset("assets/mode/$mode.png")),
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
                  child: Text(mode == 0 ? "Free Mode" : "Level Mode")),
            ),
          ],
        ),
      );

  void showChooseDialog(BuildContext context) {
    final actions = <Widget>[
      TextButton(
        child: const Text("Close"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ];
    showDialog(
        context: context,
        builder: (_) {
          return Expanded(
            child: AlertDialog(
              title: Center(
                child: Text(
                  "Choose Game Mode!",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Row(
                        children: [
                          createBoard(
                            size: 3,
                            context: context,
                            mode: 0,
                            label: "Free Mode",
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          createBoard(
                            size: 3,
                            context: context,
                            mode: 1,
                            label: "Level Mode",
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              actions: actions,
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      showChooseDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      backgroundColor: Colors.lightBlue,
    );
  }
}
