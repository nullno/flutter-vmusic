import 'package:flutter/material.dart';

class FixedSizeText extends Text {
  const FixedSizeText(String data, {
    Key key,
    TextStyle style,
    StrutStyle strutStyle,
    TextAlign textAlign,
    TextDirection textDirection,
    Locale locale,
    bool softWrap,
    TextOverflow overflow,
    double textScaleFactor = 0.9,
    int maxLines,
    String semanticsLabel,
  }) : super(data,
      key:key,
      style:style,
      strutStyle:strutStyle,
      textAlign:textAlign,
      textDirection:textDirection,
      locale:locale,
      softWrap:softWrap,
      overflow:overflow,
      textScaleFactor:textScaleFactor,
      maxLines:maxLines,
      semanticsLabel:semanticsLabel);
}