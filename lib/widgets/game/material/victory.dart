import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puzzzi/data/result.dart';
import 'package:puzzzi/links.dart';
// import 'package:puzzzi/play_games.dart';
import 'package:puzzzi/widgets/game/format.dart';
import 'package:flutter/material.dart';
import 'package:puzzzi/widgets/src/signin.dart';
import 'package:puzzzi/widgets/src/signup.dart';
import 'package:share/share.dart';

class GameVictoryDialog extends StatefulWidget {
  final Result result;

  final String Function(int) timeFormatter;

  final bool? islogged;

  const GameVictoryDialog({
    Key? key,
    required this.result,
    this.islogged,
    this.timeFormatter = formatElapsedTime,
  }) : super(key: key);

  @override
  State<GameVictoryDialog> createState() => _GameVictoryDialogState();
}

class _GameVictoryDialogState extends State<GameVictoryDialog> {
  @override
  void initState() {
    final timeFormatted = widget.timeFormatter(widget.result.time);

    var point =
        (widget.result.size ^ 2) * ((1 / widget.result.time * 1000) + 300);
    if (widget.islogged!) {
      addpoints(int.parse(point.toString()), timeFormatted);
    }

    super.initState();
  }

  void addpoints(int point, String time) {
    FirebaseFirestore.instance
        .collection("leaderboard")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        if (int.parse(value["point"]) <= point) {
          await FirebaseFirestore.instance
              .collection("leaderboard")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            "point": point,
            "time_taken": time,
            "name": FirebaseAuth.instance.currentUser!.displayName
          });
        }
      } else {
        await FirebaseFirestore.instance
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
    var point =
        (widget.result.size ^ 2) * ((1 / widget.result.time * 1000) + 300);
    final actions = <Widget>[
      TextButton(
        child: const Text("Share"),
        onPressed: () {
          Share.share("I have solved the Puzzzi's "
              "${widget.result.size}x${widget.result.size} puzzle in $timeFormatted "
              "with just ${widget.result.steps} steps! Check it out: $URL_REPOSITORY");
        },
      ),
      TextButton(
        child: const Text("Close"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ];

    // if (PlayGamesContainer.of(context).isSupported!) {
    //   actions.insert(
    //     0,
    //     new TextButton(
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
            style: const TextStyle(fontSize: 30, color: Colors.blue),
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
          if (!widget.islogged!)
            GestureDetector(
              child: Text(
                  "You are not logged in! Join the leaderboard by logging in"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SignUpPage(
                              function: () {
                                var point = (widget.result.size ^ 2) *
                                    ((1 / widget.result.time) + 300);

                                addpoints(
                                    int.parse(point.toString()), timeFormatted);
                                // addpoints(point, time)
                              },
                            )));
              },
            )
        ],
      ),
      actions: actions,
    );
  }
}
