import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:popup_menu/src/triangle_painter.dart';

import 'menu_item_widget.dart';

class GridMenuLayout {
  final MenuConfig config;
  final List<MenuItemProvider> items;
  final Rect showRect;
  final VoidCallback onDismiss;
  final BuildContext context;
  final MenuClickCallback? onClickMenu;

  GridMenuLayout({
    required this.config,
    required this.items,
    required this.showRect,
    required this.onDismiss,
    required this.context,
    this.onClickMenu,
  });

  /// row count
  int _row = 1;

  /// col count
  int _col = 1;

  /// The left top point of this menu.
  late Offset _offset;

  /// if false menu is show above of the widget, otherwise menu is show under the widget
  bool _isDown = true;

  /// The max column count, default is 4.
  int _maxColumn = 4;

  Size _screenSize = window.physicalSize / window.devicePixelRatio;

  void _calculatePosition(BuildContext context) {
    _col = _calculateColCount();
    _row = _calculateRowCount();
    _offset = _calculateOffset(PopupMenu.context);
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = showRect.left + showRect.width / 2.0 - menuWidth() / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + menuWidth() > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - menuWidth() - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = showRect.top - menuHeight();
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // The have not enough space above, show menu under the widget.
      dy = config.arrowHeight + showRect.height + showRect.top;
      _isDown = false;
    } else {
      dy -= config.arrowHeight;
      _isDown = true;
    }

    return Offset(dx, dy);
  }

  double menuWidth() {
    return config.itemWidth * _col;
  }

  // This height exclude the arrow
  double menuHeight() {
    return config.itemHeight * _row;
  }

  Widget buildPopupMenuLayout() {
    _calculatePosition(context);
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onDismiss();
        },
        onVerticalDragStart: (DragStartDetails details) {
          onDismiss();
        },
        onHorizontalDragStart: (DragStartDetails details) {
          onDismiss();
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              // triangle arrow
              Positioned(
                left: showRect.left + showRect.width / 2.0 - 7.5,
                top: _isDown
                    ? _offset.dy + menuHeight()
                    : _offset.dy - config.arrowHeight,
                child: CustomPaint(
                  size: Size(15.0, config.arrowHeight),
                  painter: TrianglePainter(
                      isDown: _isDown, color: config.backgroundColor),
                ),
              ),
              // menu content
              Positioned(
                left: _offset.dx,
                top: _offset.dy,
                child: Container(
                  width: menuWidth(),
                  height: menuHeight(),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: menuWidth(),
                            height: menuHeight(),
                            decoration: BoxDecoration(
                                color: config.backgroundColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              children: _createRows(),
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  // 创建行
  List<Widget> _createRows() {
    List<Widget> rows = [];
    for (int i = 0; i < _row; i++) {
      Color color =
          (i < _row - 1 && _row != 1) ? config.lineColor : Colors.transparent;
      Widget rowWidget = Container(
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(color: color))),
        height: config.itemHeight,
        child: Row(
          children: _createRowItems(i),
        ),
      );

      rows.add(rowWidget);
    }

    return rows;
  }

  // 创建一行的item,  row 从0开始算
  List<Widget> _createRowItems(int row) {
    List<MenuItemProvider> subItems =
        items.sublist(row * _col, min(row * _col + _col, items.length));
    List<Widget> itemWidgets = [];
    int i = 0;
    for (var item in subItems) {
      itemWidgets.add(_createMenuItem(
        item,
        i < (_col - 1),
      ));
      i++;
    }

    return itemWidgets;
  }

  // calculate row count
  int _calculateRowCount() {
    if (items.length == 0) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    int itemCount = items.length;

    if (_calculateColCount() == 1) {
      return itemCount;
    }

    int row = (itemCount - 1) ~/ _calculateColCount() + 1;

    return row;
  }

  // calculate col count
  int _calculateColCount() {
    assert(items.length > 0, 'error: menu items can not be null');

    int itemCount = items.length;
    if (_maxColumn != 4 && _maxColumn > 0) {
      return _maxColumn;
    }

    if (itemCount == 4) {
      // 4个显示成两行
      return 2;
    }

    if (itemCount <= _maxColumn) {
      return itemCount;
    }

    if (itemCount == 5) {
      return 3;
    }

    if (itemCount == 6) {
      return 3;
    }

    return _maxColumn;
  }

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  Widget _createMenuItem(MenuItemProvider item, bool showLine) {
    return MenuItemWidget(
      item: item,
      showLine: showLine,
      clickCallback: itemClicked,
      lineColor: config.lineColor,
      backgroundColor: config.backgroundColor,
      highlightColor: config.highlightColor,
    );
  }

  void itemClicked(MenuItemProvider item) {
    onClickMenu?.call(item);
    onDismiss();
  }
}
