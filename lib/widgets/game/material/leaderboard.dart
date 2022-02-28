// import 'dart:developer';

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzzi/widgets/src/signup.dart';

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
            .collection("users")
            .orderBy("level", descending: true)
            .orderBy("xp", descending: true)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
            // log(((querySnapshot.docs.first.data()! as Map)["level"] ?? 0)
            //     .toString());

            // querySnapshot.docs.sort((a, b) {
            //   return ((b.data() as Map)["level"] ?? 0)
            //       .compareTo(((a.data() as Map)["level"]) ?? 0);
            // });
            // log(((querySnapshot.docs.first.data()! as Map)["level"] ?? 0)
            //     .toString());
            // querySnapshot.docs.;

            // log(querySnapshot.docs[]);5

            // Text("DATA DEY");
            return ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (_, i) {
                  // log(querySnapshot.docs[i];

                  // log(querySnapshot.docs.toString());

                  Map documentSnapshot = querySnapshot.docs[i].data() as Map;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.primaries[i],
                      child: Text("#${i + 1}"),
                    ),
                    title: Text(documentSnapshot["username"]),
                    subtitle:
                        Text("Level " + documentSnapshot["level"].toString()),
                    trailing: Text(documentSnapshot["xp"].toString() + " XP"),
                  );
                });
          } else {
            if (FirebaseAuth.instance.currentUser == null) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SignUpPage()));
                  },
                  child: FittedBox(
                      child: Text("Sign in to view the Leaderboard")));
            }
            return const CircularProgressIndicator();
          }
          // return CircularProgressIndicator();
        },
      ),
    );
  }
}
