import 'package:flutter/material.dart';

const double height = 80;

Color urgent1 = const Color(0xffe74533);
Color background = const Color(0xff303553);
Color urgent2 = const Color(0xff6fb6f8);
Color urgent3 = const Color(0xff5dcb9a);
Color dateColor = const Color(0xfffcb322);

Color priorityColor(int no) {
  if (no == 0) {
    return urgent1;
  } else if (no == 1) {
    return urgent2;
  } else if (no == 2) {
    return urgent3;
  } else {
    return dateColor;
  }
}


TextStyle  headText = const TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 20);
TextStyle  titleText = const TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 16,fontStyle: FontStyle.italic);
TextStyle  descText = const TextStyle(color: Colors.white70,fontWeight: FontWeight.w400,fontSize: 12);