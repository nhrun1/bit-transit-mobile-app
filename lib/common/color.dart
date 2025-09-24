import 'package:flutter/material.dart';

const colorPrimary = Color(0XFF327CC8);
const colorDefaultWhite = Color(0xFFFFFFFF);

const colorAlertBlue = Color(0XFF327CC8);
const colorAlertRed = Color(0XFFDD3B3A);
const colorAlertPurple = Color(0XFF7C5DD3);
const colorAlertYellow = Color(0XFFFFC655);
const colorAlertGreen = Color(0XFF06BF71);
const colorAlertGray = Color(0XFFE2E2EC);

const colorBackgroundLightGray = Color(0XFFE9EEF4);
const colorBackgroundWhite = Color(0XFFFFFFFF);
const colorBackgroundBlack2 = Color(0XFF1E1F25);
const colorBackgroundBlack = Color(0XFF141518);

const colorGrayBlack = Color(0XFF000000);
const colorGrayGray1 = Color(0XFF8A8C92);
const colorGrayGray2 = Color(0XFF727688);
const colorGrayGray3 = Color(0XFFF4F8FB);
const colorGrayGray4 = Color(0XFFB7B8BF);
const colorGrayGray5 = Color(0XFFE2E2EC);
const colorGrayGray6 = Color(0XFF424242);
const colorGrayGray7 = Color(0XFFD3D3DF);
const colorGrayWhite = Color(0XFFFFFFFF);

extension ColorMode on Color {
  Color mode() {
    //todo: Implement Dark mode / Light mode / Custom mode
    return this;
  }
}
