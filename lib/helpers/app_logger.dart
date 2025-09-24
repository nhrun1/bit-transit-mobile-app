// ignore_for_file: unused_element

import 'dart:developer' as dev;

import 'package:bit_transit/helpers/inapp_debug_console/inapp_debug_console/inapp_debug_console_manager.dart';
import 'package:bit_transit/helpers/inapp_debug_console/inapp_debug_console/inapp_debug_console_model.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

abstract class AppLogger {
  static final Logger _logger = Logger(
    printer: _CustomPrinter(
      colors: !_isVscode,
    ),
    output: _CustomOutput(),
  );

  /// Log a message at level [Level.error].
  static void e(
    dynamic message, {
    dynamic preview,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _logger.e(
        "$preview\n$message\n-------------------------------------------------------------\n",
        error: error,
        stackTrace: stackTrace);

    InAppDebugConsoleManager.shared.add(
      InAppDebugConsoleModel(
        type: InAppDebugConsoleModelType.error,
        preview: preview,
        message: message,
        error: error,
        logTime: DateTime.now(),
        stackTrace: stackTrace,
      ),
    );
  }

  /// Log a message with log core.
  static void log(
    dynamic message, {
    dynamic preview,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      dev.log(
          "$preview\n-------------------------------------------------------------\n",
          error: error,
          stackTrace: stackTrace);
    }

    InAppDebugConsoleManager.shared.add(
      InAppDebugConsoleModel(
        type: InAppDebugConsoleModelType.log,
        preview: preview,
        message: message,
        error: error,
        logTime: DateTime.now(),
        stackTrace: stackTrace,
      ),
    );
  }

  /// Log a message with log core.
  static void logActivity(
    dynamic message, {
    dynamic preview,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      dev.log(
        "$preview\n-------------------------------------------------------------\n",
        error: error,
        stackTrace: stackTrace,
        level: 1,
      );
    }

    InAppDebugConsoleManager.shared.add(
      InAppDebugConsoleModel(
        type: InAppDebugConsoleModelType.info,
        preview: preview,
        message: message,
        error: error,
        logTime: DateTime.now(),
        stackTrace: stackTrace,
      ),
    );
  }
}

class _CustomPrinter extends PrettyPrinter {
  _CustomPrinter({
    int super.methodCount = 4,
    int super.errorMethodCount = 20,
    super.colors,
    super.printEmojis,
  });

  @override
  List<String> log(LogEvent event) {
    final tag = DateFormat("HH:mm:ss.S").format(DateTime.now());

    return super.log(
      LogEvent(
        event.level,
        "[$tag] ${event.message}",
        error: event.error,
        stackTrace: event.stackTrace,
      ),
    );
  }
}

class _CustomOutput extends ConsoleOutput {
  @override
  void output(OutputEvent event) {
    if (!kDebugMode) return;

    for (final message in event.lines) {
      if (_isVscode) {
        String start = "";
        String end = "\u001b[0m";

        switch (event.level) {
          case Level.trace:
            start = "\u001b[38;5;6m";
            break;
          case Level.debug:
            start = "\u001b[38;5;39m";
            break;
          case Level.info:
            start = "\u001b[38;5;120m";
            break;
          case Level.warning:
            start = "\u001b[38;5;13m";
            break;
          case Level.error:
            start = "\u001b[38;5;1m";
            break;
          default:
            end = "";
            break;
        }

        // ignore: unused_local_variable
        final printMessage = "$start$message$end";

        // ignore: avoid_print
        // print(printMessage);
        _printWrapped(
          message,
          startColor: start,
          endColor: end,
        );
      } else {
        // ignore: avoid_print
        // print(message);
        _printWrapped(message);
      }
    }
  }
}

void _printWrapped(
  Object? object, {
  String? startColor,
  String? endColor,
}) {
  if (object != null && object is String) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(object).forEach(
          // ignore: avoid_print
          (match) => print(
            "${startColor ?? ""}${match.group(0)}${endColor ?? ""}",
          ),
        );
  } else {
    // ignore: avoid_print
    print(object);
  }
}

bool _isVscode = const String.fromEnvironment("IDE") == "vscode";
