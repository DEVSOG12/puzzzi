import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  final double? size;
  final int? bsize;

  const AppIcon({Key? key, this.size, this.bsize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? IconTheme.of(context).size;
    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          shape: const CircleBorder(),
          elevation: 4.0,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              '$bsize',
              style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
