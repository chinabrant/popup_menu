import 'dart:developer' as console;
import 'dart:math';
import 'dart:ui';
import 'popup_menu_action.dart';
import 'package:flutter/material.dart';
import 'queue_painter.dart';

/// Animation builder.
/// You must give the following [PopupAction] actions to the child part:
typedef MenuActionsBuilder = Widget Function(
    BuildContext context, Animation<double> animation, Widget child);

class MenuLayout extends State<StatefulWidget> with TickerProviderStateMixin {
  /// Constructor [MenuLayout].
  MenuLayout(
    this.context,
    this.key, {
    required this.onPress,
    required this.actions,
    required this.width,
    required this.height,
    required this.maxRow,
    required this.decoration,
    required this.mainSpace,
    required this.crossSpace,
    this.menuBuilder,
    required this.showQueue,
    Duration? duration,
    Duration? reverseDuration,
    Offset? offset,
  })  : offset = offset ?? const Offset(0.0, 0.0),
        animationDuration = duration ?? const Duration(seconds: 1),
        animationReverseDuration = reverseDuration ?? duration,
        assert(
          width >= 0.0 && height >= 0.0,
          'Layout width and height must be greater than zero 0',
        ) {
    initState();
  }

  @override
  void initState() {
    if (menuBuilder != null) {
      _controller = AnimationController(
        vsync: this,
        duration: animationDuration,
        reverseDuration: animationReverseDuration,
      );
      _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    }
    super.initState();
  }

  /// Key of widget.
  final Key key;

  /// Menu layout context. [BuildContext].
  @override
  final BuildContext context;

  /// OnClick menu items
  ///
  /// return items index.
  final Function(int index, MenuController menu) onPress;

  /// Behind box popup menu decoration.
  final BoxDecoration decoration;

  /// Menu width.
  final double width;

  /// Menu height.
  final double height;

  /// Max column lenght.
  final int maxRow;

  /// Popup Menu actions. [PopupAction].
  /// can not be empty or null
  final List<PopupAction> actions;

  /// Animation builder.
  /// the box animations displayin.
  final MenuActionsBuilder? menuBuilder;

  /// Animation duration
  final Duration? animationDuration;

  /// Animation reverse duration.
  final Duration? animationReverseDuration;

  /// Offset of menu box.
  /// where you want it to be.
  final Offset offset;

  /// Main axis spacing.
  final double mainSpace;

  /// Cros axis spacing.
  final double crossSpace;

  /// this[popup] show queue.
  final bool showQueue;

  /// Menu show on top. Onclick which widget [Key].
  bool _isDownMenu = true;

  /// Show menu.
  bool _isShowMenu = false;

  /// Overlay entry.
  late OverlayEntry _overlayEntry;

  int column = 1;
  int row = 1;

  late AnimationController _controller;

  late Animation<double> _animation;

  late MenuController _menu;

  Widget _animatedBuilder(child) {
    return menuBuilder!(context, _animation, child);
  }

  int get _menuLength => actions.length;

  Size get _screenSize => window.physicalSize / window.devicePixelRatio;

  double get _topPadding => MediaQuery.of(context).padding.top;

  double get _menuWidth {
    if (column == 1) {
      return column * width + 15.0 + column * 10;
    }
    return column * width + ((column - 1) * mainSpace) + 15.0 + column * 10;
  }

  double get _menuHeight {
    return row * height + ((row - 1) * crossSpace) + 10.0 + row * 10;
  }

  double _mainAxisSpace(index) {
    return index != 0 && (index % column != 0) ? mainSpace : 0.0;
  }

  double _crossAxisSpace(index) {
    if (row == 1) {
      return height / 15.0;
    }
    if (index >= column) {
      return crossSpace;
    }
    return 0.0;
  }

  Rect get _rect {
    RenderBox renderBox =
        (key as GlobalKey).currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final rect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    return rect;
  }

  Offset get _offset {
    double dx = _rect.left + _rect.width / 2 - _menuWidth / 2;
    if (dx < 10) dx = 10.0 * 2;
    if (dx + _menuWidth > _screenSize.width && dx > 10.0) {
      double temp = _screenSize.width - _menuWidth - 10.0;
      if (temp > 10.0) dx = temp;
    }

    double dy = _rect.top - _menuHeight;
    if (dy <= _topPadding + 10) {
      dy = 10.0 + _rect.height + _rect.top;
      _isDownMenu = false;
    } else {
      dy -= 10;
      _isDownMenu = true;
    }
    return Offset(dx + offset.dx, dy + offset.dy);
  }

  void _setOverlay() {
    _overlayEntry = OverlayEntry(builder: (_) => build(context));
  }

  void _columnCount(int menuLength) {
    if (maxRow > menuLength) {
      column = menuLength;
      return;
    }
    if (maxRow > 0) {
      column = maxRow;
      return;
    }
  }

  void _rowCount(int menuLength) {
    if (column == 1) {
      row = menuLength;
      return;
    }
    row = (menuLength - 1) ~/ column + 1;
  }

  void _setPosition(int menuLength) {
    _columnCount(menuLength);
    _rowCount(menuLength);
  }

  void showMenu() {
    _setPosition(_menuLength);
    _setOverlay();
    Overlay.of(context)!.insert(_overlayEntry);
    if (menuBuilder != null) {
      _controller.forward();
    }
    _isShowMenu = true;

    console.log('Display Popup Menu');
  }

  void _closeMenu() {
    if (!_isShowMenu) return;
    if (menuBuilder != null) {
      _controller.dispose();
    }
    _overlayEntry.remove();
    _isShowMenu = false;
    console.log('Dispose Popup Menu');
  }

  List<Widget> get _rows {
    List<Widget> rowItem = [];
    int itemIndex = 0;
    for (var rowIndex = 0; rowIndex < row; rowIndex++) {
      List<Widget> rowInsideItem = [];
      List<PopupAction> subItems = actions.sublist(
        rowIndex * column,
        min(rowIndex * column + column, actions.length),
      );
      for (PopupAction item in subItems) {
        if (column != 1) {
          rowInsideItem.add(_menuItemRow(item, itemIndex));
        } else {
          rowInsideItem.add(_menuItemColumn(item, itemIndex));
        }
        itemIndex++;
      }
      rowItem.add(Row(children: rowInsideItem));
    }
    return rowItem;
  }

  void _onClickMenuItem(int index) {
    _menu = MenuController(_overlayEntry)
      .._addListener(
        () {
          _overlayEntry.remove();
        },
      );
    onPress.call(index, _menu);
  }

  Widget _menuItemRow(Widget child, int itemIndex) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          left: _mainAxisSpace(itemIndex),
          top: _crossAxisSpace(itemIndex),
        ),
        child: InkWell(
          onTap: () => _onClickMenuItem(itemIndex),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: width,
              height: height,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuItemColumn(PopupAction action, int index) {
    final item = (Flexible(
      child: action.item,
    ));
    Widget title = const SizedBox();
    if (action.title != null) {
      title = Flexible(
        flex: 5,
        child: Text(
          action.title!,
          style: action.style,
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          left: _mainAxisSpace(index),
          top: _crossAxisSpace(index),
        ),
        child: InkWell(
          onTap: () => _onClickMenuItem(index),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              width: width,
              height: height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  item,
                  const SizedBox(width: 5.0),
                  title,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget get _childBox {
    return Container(
      padding: EdgeInsets.only(
        left: 5.0,
        right: 5.0,
        top: row != 1 ? 5.0 : 2.5,
        bottom: row != 1 ? 0.0 : 2.5,
      ),
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _rows,
      ),
    );
  }

  Widget get _buildPopupBox {
    Widget children = Stack(
      children: [
        Container(),
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          width: _menuWidth,
          height: _menuHeight,
          child: _childBox,
        ),
        Visibility(
          visible: showQueue,
          child: _childQueue,
        ),
      ],
    );
    if (menuBuilder != null) {
      return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => _animatedBuilder(child),
          child: children);
    } else {
      return children;
    }
  }

  Positioned get _childQueue {
    return Positioned(
      left: _rect.left + _rect.width / 2.0 - 7.5 + offset.dx,
      top: _isDownMenu ? _offset.dy + _menuHeight : _offset.dy - 10.0,
      child: CustomPaint(
        size: Size(15.0, 10.0),
        painter: QueuePainter(
          isDown: _isDownMenu,
          color: decoration.color!,
        ),
      ),
    );
  }

  GestureDetector _buildListen(BoxConstraints constraints) {
    return GestureDetector(
      onTap: () => _closeMenu(),
      onTapDown: (_) => _closeMenu(),
      onVerticalDragStart: (_) => _closeMenu(),
      onHorizontalDragStart: (_) => _closeMenu(),
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: Colors.transparent,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
      ),
    );
  }

  LayoutBuilder get _buildLayout {
    final builder = LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            _buildListen(constraints),
            _buildPopupBox,
          ],
        );
      },
    );
    return builder;
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayout;
  }
}

class MenuController {
  late Function() _close;
  MenuController(OverlayEntry overlayEntry);
  _addListener(Function() _close) {
    this._close = _close;
  }

  /// Close menu actions. [Fucntion<void>]
  void close() => _close();
}
