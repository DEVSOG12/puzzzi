import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("leaderboard").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              log(snapshot.data.toString());

              Text("DATA DEY");
              // return ListView.builder(

              // itemCount: snapshot.data,
              // itemBuilder: itemBuilder)
            } else {
              return CircularProgressIndicator();
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
