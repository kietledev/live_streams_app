import 'package:flutter/material.dart';
import 'package:live_streams_app/common/helpers/constants.dart';

class Utils {
  Utils._();

  static TextStyle setStyle(
      {Color? color = Colors.black,
      String? fontFamily = notoSans,
      FontWeight? weight = FontWeight.w400,
      double? size = 16}) {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontWeight: weight,
      fontSize: size,
    );
  }
}

const _epochTicks = 621356220000000000;

extension TicksOnDateTime on DateTime {
  int get ticks => microsecondsSinceEpoch * 10 + _epochTicks;
}
