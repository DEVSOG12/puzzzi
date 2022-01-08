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
              QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
              // log(querySnapshot.docs[]);

              // Text("DATA DEY");
              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, i) {
                    DocumentSnapshot documentSnapshot =
                        querySnapshot.docs[i].data() as DocumentSnapshot;
                    return ListTile(
                      leading: Text(documentSnapshot["name"]),
                      subtitle: Text(documentSnapshot["point"]),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
            // return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
