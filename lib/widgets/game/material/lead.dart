import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puzzzi/data/result.dart';
import 'package:puzzzi/links.dart';
// import 'package:puzzzi/play_games.dart';
import 'package:puzzzi/widgets/game/format.dart';
import 'package:flutter/material.dart';
import 'package:puzzzi/widgets/game/material/leaderboard.dart';
import 'package:share/share.dart';

class Lead extends StatefulWidget {
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
      new FlatButton(
        child: new Text("Close"),
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
          LeaderBoard(),
      // ],
      // ),
      actions: actions,
    );
  }
}
