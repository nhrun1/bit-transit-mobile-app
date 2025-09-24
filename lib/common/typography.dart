// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

/// FontFamily: SF Pro Display

const tStyle = TextStyle(fontFamily: "Inter");

extension Typography on TextStyle {
  ///
  TextStyle fs({double? fontSize, double? height}) {
    return copyWith(fontSize: fontSize, height: height);
  }

  ///
  TextStyle fw(FontWeight? fontWeight) {
    return copyWith(fontWeight: fontWeight);
  }

  TextStyle tColor(Color? color) {
    return copyWith(color: color);
  }

  TextStyle tFamily(String family) {
    return copyWith(fontFamily: family);
  }

  TextStyle get H1 => copyWith(fontSize: 48, height: 56 / 48);

  TextStyle get H2 => copyWith(fontSize: 40, height: 48 / 40);

  TextStyle get H3 => copyWith(fontSize: 32, height: 40 / 32);

  TextStyle get H4 => copyWith(fontSize: 28, height: 32 / 28);

  TextStyle get H5 => copyWith(fontSize: 24, height: 32 / 24);

  TextStyle get H6 => copyWith(fontSize: 20, height: 28 / 20);

  TextStyle get H6B => copyWith(fontSize: 20, height: 28 / 20, fontWeight: FontWeight.bold);

  TextStyle get body1 => copyWith(fontSize: 18, height: 24 / 18);

  TextStyle get body2 => copyWith(fontSize: 16, height: 22 / 16);

  TextStyle get body3 => copyWith(fontSize: 14, height: 20 / 14);

  TextStyle get body4 => copyWith(fontSize: 12, height: 16 / 12);

  TextStyle get body5 => copyWith(fontSize: 10, height: 14 / 10);

  TextStyle get Bold => fw(FontWeight.w700);

  TextStyle get Medium => fw(FontWeight.w500);

  TextStyle get Regular => fw(FontWeight.w400);

  TextStyle get Light => fw(FontWeight.w300);
}
