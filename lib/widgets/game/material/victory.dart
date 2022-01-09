import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puzzzi/data/result.dart';
import 'package:puzzzi/links.dart';
// import 'package:puzzzi/play_games.dart';
import 'package:puzzzi/widgets/game/format.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GameVictoryDialog extends StatefulWidget {
  final Result result;

  final String Function(int) timeFormatter;

  GameVictoryDialog({
    required this.result,
    this.timeFormatter: formatElapsedTime,
  });

  @override
  State<GameVictoryDialog> createState() => _GameVictoryDialogState();
}

class _GameVictoryDialogState extends State<GameVictoryDialog> {
  @override
  void initState() {
    final timeFormatted = widget.timeFormatter(widget.result.time);

    var point =
        (widget.result.size ^ 2) * (1 / int.parse(timeFormatted[0])) + 300;

    addpoints(int.parse(point.toString()), timeFormatted);

    super.initState();
  }

  void addpoints(int point, String time) {
    FirebaseFirestore.instance
        .collection("leaderboard")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        if (int.parse(value["point"]) <= point) {
          FirebaseFirestore.instance
              .collection("leaderboard")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            "point": point,
            "time_taken": time,
            "name": FirebaseAuth.instance.currentUser!.displayName
          });
        }
      } else {
        FirebaseFirestore.instance
            .collection("leaderboard")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "point": point,
          "time_taken": time,
          "name": FirebaseAuth.instance.currentUser!.displayName
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeFormatted = widget.timeFormatter(widget.result.time);
    var point = (widget.result.size ^ 2) *
            (1 / int.parse(timeFormatted.substring(0, 1))) +
        300;
    final actions = <Widget>[
      new FlatButton(
        child: new Text("Share"),
        onPressed: () {
          Share.share("I have solved the Puzzzi's "
              "${widget.result.size}x${widget.result.size} puzzle in $timeFormatted "
              "with just ${widget.result.steps} steps! Check it out: $URL_REPOSITORY");
        },
      ),
      new FlatButton(
        child: new Text("Close"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ];

    // if (PlayGamesContainer.of(context).isSupported!) {
    //   actions.insert(
    //     0,
    //     new FlatButton(
    //       child: new Text("Leaderboard"),
    //       onPressed: () {
    //         final playGames = PlayGamesContainer.of(context);
    //         playGames.showLeaderboard(
    //           key: PlayGames.getLeaderboardOfSize(widget.result.size),
    //         );
    //       },
    //     ),
    //   );
    // }

    return AlertDialog(
      title: Center(
        child: Text(
          "Congratulations!",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Points: $point",
            style: TextStyle(fontSize: 30, color: Colors.blue),
          ),
          Text(
              "You've successfuly completed the ${widget.result.size}x${widget.result.size} puzzle"),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Time:',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    timeFormatted,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Steps:',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '${widget.result.steps}',
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: actions,
    );
  }
}
