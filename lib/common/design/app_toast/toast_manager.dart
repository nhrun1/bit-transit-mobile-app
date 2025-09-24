import 'dart:async';

import 'package:bit_transit/helpers/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:overlay_support/overlay_support.dart';
part 'animated_widget.dart';

class ToastManager {
  ToastManager._internal();
  static ToastManager? _instance;

  static ToastManager get shared {
    _instance ??= ToastManager._internal();

    return _instance!;
  }

  GlobalKey<_AnimatedWidgetState> _key = GlobalKey();
  OverlaySupportEntry? _overlay;

  bool get isShowing => _overlay != null;

  Future<void> show({
    required Widget view,
    BuildContext? context,
    Duration? duration,
    bool? isVisibleForever,
    Function()? onHide,
    Function()? onHideWhenShowNewAfter,
    required String debugLabel,
  }) async {
    try {
      AppLogger.logActivity(
        "",
        preview: "Show Toast $debugLabel",
      );
      if (_overlay != null) {
        await _key.currentState?.hide(isShowNewAfter: true);
        _reset();
      }

      _key = GlobalKey();
      _overlay ??= showOverlay(
        (_, __) => _AnimatedWidget(
          key: _key,
          duration: duration,
          isVisibleForever: isVisibleForever,
          onHide: () {
            onHide?.call();
            _reset();
          },
          onHideWhenShowNewAfter: onHideWhenShowNewAfter,
          child: view,
        ),
        context: context?.mounted == true ? context : null,
        duration: Duration.zero,
      );
    } catch (e) {
      AppLogger.e("", preview: e);

      _overlay = null;
    }
  }

  Future<void> hide() async {
    await _key.currentState?.hide();
    _reset();
  }

  void _reset() {
    try {
      _overlay?.dismiss(animate: false);
      _overlay = null;
    } catch (e) {
      AppLogger.e("", preview: e);

      _overlay = null;
    }
  }
}
