import 'package:flutter/material.dart';

enum InAppDebugConsoleModelType {
  print,
  log,
  verbose,
  debug,
  info,
  warning,
  error,
}

class InAppDebugConsoleModel {
  final InAppDebugConsoleModelType type;
  final Color color;
  final dynamic preview;
  final dynamic message;
  final dynamic error;
  final dynamic stackTrace;
  final DateTime logTime;

  InAppDebugConsoleModel({
    required this.type,
    required this.preview,
    required this.message,
    this.error,
    this.stackTrace,
    required this.logTime,
  }) : color = _getColorByType(type);

  static Color _getColorByType(InAppDebugConsoleModelType type) {
    return Colors.transparent;
  }

  InAppDebugConsoleModel._({
    required this.type,
    required this.color,
    required this.preview,
    required this.message,
    required this.logTime,
    this.error,
    this.stackTrace,
  });

  InAppDebugConsoleModel copyWith({
    InAppDebugConsoleModelType? type,
    Color? color,
    dynamic preview,
    dynamic message,
    dynamic error,
    dynamic stackTrace,
    DateTime? logTime,
  }) {
    return InAppDebugConsoleModel._(
      type: type ?? this.type,
      color: color ?? this.color,
      preview: preview ?? this.preview,
      message: message ?? this.message,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      logTime: logTime ?? this.logTime,
    );
  }
}
