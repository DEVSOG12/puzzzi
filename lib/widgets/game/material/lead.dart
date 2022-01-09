// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:puzzzi/play_games.dart';
import 'package:flutter/material.dart';
import 'package:puzzzi/widgets/game/material/leaderboard.dart';

class Lead extends StatefulWidget {
  const Lead({Key? key}) : super(key: key);

  @override
  State<Lead> createState() => _LeadState();
}

class _LeadState extends State<Lead> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[
      TextButton(
        child: const Text("Close"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ];

    return AlertDialog(
      title: Center(
        child: Text(
          "LeaderBoard",
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      content:
          // Column(
          // mainAxisSize: MainAxisSize.min,
          // children: <Widget>[
          const LeaderBoard(),
      // ],
      // ),
      actions: actions,
    );
  }
}
