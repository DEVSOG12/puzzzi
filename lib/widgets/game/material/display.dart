import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puzzzi/data/board.dart';
import 'package:puzzzi/data/result.dart';
import 'package:puzzzi/links.dart';
// import 'package:puzzzi/play_games.dart';
import 'package:puzzzi/widgets/game/format.dart';
import 'package:flutter/material.dart';
import 'package:puzzzi/widgets/game/presenter/main.dart';

import '../board.dart';

class DisplayDialog extends StatefulWidget {
  final int? level;

  final GamePresenterWidgetState? pres;

  const DisplayDialog({
    Key? key,
    this.pres,
    this.level,
  }) : super(key: key);

  @override
  State<DisplayDialog> createState() => _DisplayDialogState();
}

class _DisplayDialogState extends State<DisplayDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget createBoard({int? size, int? level}) => Center(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.height / 3,
                // width: ,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(4.0),
                // decoration: BoxDecoration(
                //   color: Theme.of(context).brightness == Brightness.dark
                //       ? Colors.white70
                //       : Colors.black12,
                //   borderRadius: BorderRadius.circular(8.0),
                // ),
                child: Semantics(
                  label: '${size}x$size',
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final puzzleSize = min(
                          min(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          96.0,
                        );

                        return Semantics(
                          excludeSemantics: true,
                          child: BoardWidget(
                            mode: true,
                            level: level,
                            isSpeedRunModeEnabled: true,
                            board: widget.pres!.board,
                            onTap: (point) {
                              print(point);
                            },
                            showNumbers: false,
                            size: puzzleSize,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Semantics(
                excludeSemantics: true,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('${size}x$size'),
                ),
              ),
            ],
          ),
        );
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
          Row(
            children: <Widget>[
              const SizedBox(width: 8),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: createBoard(size: 3, level: 31),
                ),
              ),
              Expanded(child: createBoard(size: 3, level: 51)),
              Expanded(child: createBoard(size: 3, level: 71)),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: createBoard(size: 3, level: 91),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
