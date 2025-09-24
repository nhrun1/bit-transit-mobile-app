part of 'toast_manager.dart';

class _AnimatedWidget extends StatefulWidget {
  final Duration? duration;
  final bool? isVisibleForever;
  final Function()? onHide;
  final Function()? onHideWhenShowNewAfter;
  final Widget child;

  const _AnimatedWidget({
    super.key,
    this.duration,
    this.isVisibleForever,
    this.onHide,
    this.onHideWhenShowNewAfter,
    required this.child,
  });

  @override
  State<_AnimatedWidget> createState() => _AnimatedWidgetState();
}

class _AnimatedWidgetState extends State<_AnimatedWidget>
    with SingleTickerProviderStateMixin {
  final _defaultVisibleDuration = const Duration(milliseconds: 3000);
  final _defaultInDuration = const Duration(milliseconds: 300);
  final _defaultOutDuration = const Duration(milliseconds: 300);
  final _defaultQuickOutDuration = const Duration(milliseconds: 200);

  late AnimationController _controller;

  double _lastDy = 0;
  double _dy = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _defaultInDuration,
      reverseDuration: _defaultOutDuration,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!(widget.isVisibleForever ?? false)) {
        _timer = Timer(
          widget.duration ?? _defaultVisibleDuration,
          hide,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          top: _dy,
          left: 0,
          right: 0,
          duration: const Duration(milliseconds: 80),
          child: GestureDetector(
            onPanDown: (details) {
              _controller.stop();
              _timer?.cancel();
              _lastDy = details.localPosition.dy;
            },
            onPanUpdate: (details) {
              if (details.localPosition.dy > _lastDy) return;
              setState(() {
                _dy += details.delta.dy;
              });
            },
            onPanEnd: (_) => hide(),
            onPanCancel: hide,
            child: widget.child.animate(controller: _controller).slideY(
                  begin: -1,
                  end: 0,
                  curve: Curves.fastOutSlowIn,
                ),
          ),
        ),
      ],
    );
  }

  Future<void> hide({
    bool isShowNewAfter = false,
  }) async {
    if (isShowNewAfter) {
      _controller.reverseDuration = _defaultQuickOutDuration;
    }
    await _controller.reverse();
    _controller.reverseDuration = _defaultOutDuration;
    if (ToastManager.shared.isShowing) {
      _timer?.cancel();
      if (isShowNewAfter) {
        widget.onHideWhenShowNewAfter?.call();
      } else {
        widget.onHide?.call();
      }
    }
  }
}
