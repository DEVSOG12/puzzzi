// import 'dart:developer';

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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("leaderboard")
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
            querySnapshot.docs.sort((a, b) {
              return ((b.data() as Map)["point"])
                  .compareTo(((a.data() as Map)["point"]));
            });
            // querySnapshot.docs.;

            // log(querySnapshot.docs[]);5

            // Text("DATA DEY");
            return ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (_, i) {
                  // log(querySnapshot.docs[i].toString());

                  log(querySnapshot.docs.toString());

                  Map documentSnapshot = querySnapshot.docs[i].data() as Map;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.primaries[i],
                      child: Text("#${i + 1}"),
                    ),
                    title: Text(documentSnapshot["name"]),
                    subtitle:
                        Text(documentSnapshot["point"].toString() + " Points"),
                    trailing: Text(documentSnapshot["time_taken"]),
                  );
                });
          } else {
            return const CircularProgressIndicator();
          }
          // return CircularProgressIndicator();
        },
      ),
    );
  }
}
