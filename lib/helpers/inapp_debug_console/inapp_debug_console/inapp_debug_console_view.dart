part of 'inapp_debug_console_manager.dart';

class InAppDebugConsoleView extends StatefulWidget {
  final List<InAppDebugConsoleModel> datas;

  const InAppDebugConsoleView({
    super.key,
    required this.datas,
  });

  @override
  State<InAppDebugConsoleView> createState() => _InAppDebugConsoleViewState();
}

class _InAppDebugConsoleViewState extends State<InAppDebugConsoleView> {
  StreamSubscription? _streamSubscription;
  late final List<InAppDebugConsoleModel> _originDatas = [...widget.datas];
  final _scrollController = ScrollController();
  final _filterTextEditingController = TextEditingController();
  List<InAppDebugConsoleModel> _datas = [];
  final String _localKeywordFilter = _keywordFilter;

  @override
  void initState() {
    super.initState();
    _filterTextEditingController.text = _localKeywordFilter;

    _streamSubscription =
        _inAppDebugConsoleController.stream.listen(_handleListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _filter();
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _filterTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1e2127),
      child: SafeArea(
        child: Stack(
          children: [
          ],
        ),
      ),
    );
  }

  void _handleListener(InAppDebugConsoleModel data) {
    // handle _originDatas
    try {
      if (_originDatas.length >= _maxData) {
        _originDatas.removeLast();
      }
    } catch (_) {}
    _originDatas.insert(0, data);

    // handle _datas
    if (_localKeywordFilter.isNotEmpty) {
      if ((data.message ?? "")
              .toString()
              .toLowerCase()
              .contains(_localKeywordFilter.toLowerCase()) ||
          (data.error ?? "")
              .toString()
              .toLowerCase()
              .contains(_localKeywordFilter.toLowerCase()) ||
          (data.stackTrace ?? "")
              .toString()
              .toLowerCase()
              .contains(_localKeywordFilter.toLowerCase()) ||
          (data.preview ?? "")
              .toString()
              .toLowerCase()
              .contains(_localKeywordFilter.toLowerCase())) {
        try {
          if (_datas.length >= _maxData) {
            _datas.removeLast();
          }
        } catch (_) {}
        _datas.insert(0, data);
      }
    } else {
      try {
        if (_datas.length >= _maxData) {
          _datas.removeLast();
        }
      } catch (_) {}
      _datas.insert(0, data);
    }

    setState(() => {});
  }

  void _filter() {
    if (_localKeywordFilter.isEmpty) {
      _datas.clear();
      _datas.addAll([..._originDatas]);
      setState(() => {});
    } else {
      _datas.clear();
      _datas.addAll(
        _originDatas.where((e) {
          return (e.message ?? "")
                  .toString()
                  .toLowerCase()
                  .contains(_localKeywordFilter.toLowerCase()) ||
              (e.error ?? "")
                  .toString()
                  .toLowerCase()
                  .contains(_localKeywordFilter.toLowerCase()) ||
              (e.stackTrace ?? "")
                  .toString()
                  .toLowerCase()
                  .contains(_localKeywordFilter.toLowerCase()) ||
              (e.preview ?? "")
                  .toString()
                  .toLowerCase()
                  .contains(_localKeywordFilter.toLowerCase());
        }).toList(),
      );
    }
  }
}

class RowDetails extends StatefulWidget {
  const RowDetails({
    super.key,
    required this.item,
    required this.textColor,
  });

  final InAppDebugConsoleModel item;
  final Color textColor;

  @override
  State<RowDetails> createState() => _RowDetailsState();
}

class _RowDetailsState extends State<RowDetails> {
  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                "[${DateFormat("HH:mm:ss dd/MM/yyyy").format(widget.item.logTime)}]\n${widget.item.preview ?? "-"}",
                style: tStyle.tColor(widget.textColor),
              ),
              if (isExpand)
                SelectableText(
                  "\n\n${widget.item.message}",
                  style: tStyle.tColor(widget.textColor),
                ),
            ],
          ),
        ),
        Row(
          children: [
            if (widget.item.message != null && widget.item.message != "")
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpand = !isExpand;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    !isExpand ? Icons.arrow_downward : Icons.arrow_upward,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            GestureDetector(
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: widget.item.message),
                );
                ToastManager.shared.show(
                  view: const AppToastWidget(
                    title: "Copied",
                    type: AppToastType.success,
                  ),
                  debugLabel: "Clipboard",
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
