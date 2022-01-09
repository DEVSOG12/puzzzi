import 'dart:developer';
// import 'dart:math' hide log;

import 'package:flutter/material.dart' hide Chip;

class ChipWidget extends StatelessWidget {
  // mich == null ? mich =  : mich = mich;
  final String? text;

  final Function? onPressed;

  final int boardsize;

  final int mich;

  final Color overlayColor;

  final Color backgroundColor;

  final double fontSize;

  final double size;

  const ChipWidget(
    this.text,
    this.overlayColor,
    this.backgroundColor,
    this.fontSize, {Key? key, 
    required this.onPressed,
    required this.size,
    required this.mich,
    required this.boardsize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompact = size < 150;
    List images3x3 = [9, 8, 7, 6, 5, 4, 3, 2, 1];
    List images4x4 = [16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1];
    // @formatter:off
    List images5x5 = [
      25,
      24,
      23,
      22,
      21,
      20,
      19,
      18,
      17,
      16,
      15,
      14,
      13,
      12,
      11,
      10,
      9,
      8,
      7,
      6,
      5,
      4,
      3,
      2,
      1
    ];

// @formatter:on

    String? assets() {
      if (boardsize == 3) {
        return "assets/${(mich + 1).toString()}/3x3/${images3x3[(int.parse(text!) - 1)]}.png";
      }
      if (boardsize == 4) {
        return "assets/${(mich + 1).toString()}/4x4/${images4x4[(int.parse(text!) - 1)]}.png";
      }
      if (boardsize == 5) {
        return "assets/${(mich + 1).toString()}/5x5/${images5x5[(int.parse(text!) - 1)]}.png";
      }
    }

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(isCompact ? 4.0 : 8.0)),
    );

    var color = Theme.of(context).cardColor;
    color = Color.alphaBlend(backgroundColor, color);
    color = Color.alphaBlend(overlayColor, color);

    log(color.toString() + backgroundColor.toString());
    return Semantics(
      label: "",
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 2.0 : 4.0),
        child: InkWell(
          onTap: onPressed as void Function()?,
          customBorder: shape,
          child: Material(
            shape: shape,
            color: Colors.transparent,
            elevation: 1,
            child: text != null
                ? Container(
                    child: Center(
                        child: Text(
                      text!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                          color: color.toString() == "Color(0xff1e1e1e)" ||
                                  color.toString() == "Color(0x0026d9d9)"
                              ? Colors.black87
                              : color),
                    )),
                    height: 190.0,
                    width: MediaQuery.of(context).size.width - 100.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue,
                        image: DecorationImage(
                            image: AssetImage(assets()!),
                            fit: BoxFit.fill)),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
