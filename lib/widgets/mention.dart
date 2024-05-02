import 'package:flutter/material.dart';

class Mention {
  String type;  // either be "user" or "thread" (@ or #)
  String targetName;
  //String targetID;   --> for redirecting to which userID / threadID

  Mention(this.type, this.targetName);


  Widget toWidget(
      {
        EdgeInsetsGeometry? padding,
        TextStyle? textStyle
      }
    ) {
    return GestureDetector(
      onTap: () {        
      },
      child: Container(
        padding: padding,
        child: Text(
          toString(),
          style: textStyle
        ),
      ),
    );
  }

  @override
  String toString() {
    if (type == "user") {
      return "@$targetName";
    } else if (type == "thread") {
      return "#$targetName";
    } else {
      throw "Invalid Mention.type";
    }
  }
}