import 'dart:async';
import 'package:bit_transit/common/design/app_toast/app_toast_widget.dart';
import 'package:bit_transit/common/design/app_toast/toast_manager.dart';
import 'package:bit_transit/common/typography.dart';
import 'package:bit_transit/constants/constants.dart';
import 'package:bit_transit/helpers/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'inapp_debug_console_model.dart';

part 'inapp_debug_console_view.dart';

final _inAppDebugConsoleController =
    StreamController<InAppDebugConsoleModel>.broadcast();
const int _maxData = 100;
String _keywordFilter = "";

class InAppDebugConsoleManager {
  InAppDebugConsoleManager._internal();
  static InAppDebugConsoleManager? _instance;

  static InAppDebugConsoleManager get shared {
    _instance ??= InAppDebugConsoleManager._internal();

    return _instance!;
  }

  OverlaySupportEntry? _overlay;
  bool get isShowing => _overlay != null;

  final List<InAppDebugConsoleModel> _datas = [];

  void show() {
    if (!_canDebug) return;

    if (isShowing) hide();

    try {
      _overlay ??= showOverlay(
        (_, __) => SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: InAppDebugConsoleView(
            datas: _datas,
          ),
        ),
        duration: Duration.zero,
      );
    } catch (e) {
      AppLogger.e("", preview: e);
      _overlay = null;
    }
  }

  void hide() {
    try {
      _overlay?.dismiss(animate: false);
      _overlay = null;
    } catch (e) {
      AppLogger.e("", preview: e);

      _overlay = null;
    }
  }

  void add(InAppDebugConsoleModel data) {
    if (!_canDebug) return;

    try {
      if (_datas.length >= _maxData) {
        _datas.removeLast();
      }
    } catch (_) {}
    _datas.insert(0, data);
    _inAppDebugConsoleController.sink.add(data);
  }

  void clear() {
    _datas.clear();
  }

  bool get _canDebug => Constants.of().flavor == Flavor.dev;
}

class InappDebugConsoleWidget extends StatefulWidget {
  const InappDebugConsoleWidget({super.key});

  @override
  State<InappDebugConsoleWidget> createState() =>
      _InappDebugConsoleWidgetState();
}

class _InappDebugConsoleWidgetState extends State<InappDebugConsoleWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
