import 'package:bit_transit/common/color.dart';
import 'package:bit_transit/common/design/loading/loading_widget.dart';
import 'package:bit_transit/helpers/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class LoadingManager {
  // Singleton
  LoadingManager._internal();
  static LoadingManager? _instance;

  static LoadingManager get shared {
    _instance ??= LoadingManager._internal();

    return _instance!;
  }

  // Variables
  final List<dynamic> _stack = [];
  OverlaySupportEntry? _overlay;

  bool get isShowing => _overlay != null;

  void show({
    BuildContext? context,
    String? tag,
  }) {
    try {
      _stack.add(tag);

      _overlay ??= showOverlay(
        (_, __) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => {},
          child: Container(
            color: colorGrayBlack.withOpacity(0.6),
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: LoadingWidget(),
            ),
          ),
        ),
        context: context,
        duration: Duration.zero,
      );

      final message =
          "Show loading with tag: $tag\nStack Loading:\n${_stack.map((e) => "\n$e").toList()}";
      AppLogger.logActivity("", preview: message);
      // AppLogger.simpleD(message);
      // TroubleShootingLog.insertLog(
      //   LogType.INFO,
      //   LogService.POPUP,
      //   message,
      // );
    } catch (e) {
      AppLogger.e("", preview: e);

      _stack.remove(tag);
      _overlay = null;
    }
  }

  void hide({String? tag}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      // ignore: unused_local_variable
      final isRemoveSuccess = _stack.remove(tag);

      if (_stack.isEmpty) {
        _overlay?.dismiss(animate: false);
        _overlay = null;
      }

      if (isRemoveSuccess) {
        final message =
            "Hide loading with tag: $tag\nStack Loading:\n${_stack.map((e) => "\n$e").toList()}";

        AppLogger.logActivity("", preview: "$message\n");
      }
    } catch (e) {
      AppLogger.e("", preview: e);

      _overlay = null;
    }
  }

  void clear() async {
    await Future.delayed(const Duration(milliseconds: 100));

    _stack.clear();

    _overlay?.dismiss(animate: false);
    _overlay = null;

    const message = "Clear all loading";
    AppLogger.log("", preview: message);
  }
}
