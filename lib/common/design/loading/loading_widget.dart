import 'package:bit_transit/common/color.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.px,
      width: 60.px,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.px),
        color: Colors.black.withOpacity(0.7),
      ),
      child: LoadingAnimationWidget.flickr(
        leftDotColor: colorPrimary,
        rightDotColor: colorAlertRed,
        size: 20,
      ),
    );
  }
}
