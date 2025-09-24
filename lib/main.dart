import 'package:bit_transit/features/app/bit_transit_app.dart';
import 'package:bit_transit/helpers/app_logger.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppLogger.e(
      "${details.exception.toString()}\n${details.toString()}",
      preview: "CUONG.DOAN: Runzone Err...",
      error: "${details.exception.toString()}\n${details.toString()}",
      stackTrace: details.stack,
    );
  };
  runApp(const BitTransitApp());
}
