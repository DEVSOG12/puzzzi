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
                    querySnapshot.docs.sort((a, b) {
                      return int.parse((a.data() as Map)["point"])
                          .compareTo(int.parse((b.data() as Map)["point"]));
                    });
                    querySnapshot.docs.reversed;
                    Map documentSnapshot = querySnapshot.docs[i].data() as Map;
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text("#${i + 1}"),
                      ),
                      title: Text(documentSnapshot["name"]),
                      subtitle:
                          Text(documentSnapshot["point"].toString() + " Points"),
                      trailing: Text(documentSnapshot["time_taken"]),
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
