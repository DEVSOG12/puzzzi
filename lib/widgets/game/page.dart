import 'package:puzzzi/data/result.dart';
// import 'package:puzzzi/play_games.dart';
import 'package:puzzzi/widgets/game/material/page.dart';
import 'package:puzzzi/widgets/game/material/victory.dart';
import 'package:puzzzi/widgets/game/presenter/main.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class GamePage extends StatelessWidget {
  final bool? islogged;
  const GamePage({Key? key, this.islogged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rootWidget = _buildRoot(context);
    return GamePresenterWidget(
      child: rootWidget,
      onSolve: (result) {
        // _submitResult(context, result);
        _showVictoryDialog(context, result);
      },
    );
  }

  Widget _buildRoot(BuildContext context) {
    return GameMaterialPage(
      islogged: islogged,
    );
  }

  void _showVictoryDialog(BuildContext context, Result result) {
    showDialog(
      context: context,
      builder: (context) => GameVictoryDialog(result: result),
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
