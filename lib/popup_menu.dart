library popup_menu;

import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'triangle_painter.dart';

abstract class MenuItemProvider {
  String get menu_title;
  // Image get menu_image;
  Widget get menu_image;
}

class MenuItem extends MenuItemProvider {
  Widget image; // 图标名称
  String title;     // 菜单标题
  var userInfo;     // 额外的菜单荐信息

  MenuItem({this.title, this.image, this.userInfo});

  @override
  Widget get menu_image => image;

  @override
  String get menu_title => title;
}

enum MenuType {
  big, oneLine
}

typedef MenuClickCallback = Function(MenuItemProvider item);

/**
 * popup menu
 */
class PopupMenu {
  static var itemWidth = 72.0;
  static var itemHeight = 65.0;
  static var arrowHeight = 10.0;
  OverlayEntry _entry;
  List<MenuItem> items;
  int _row; // row count
  int _col; // col count
  Offset _offset; // 菜单左上角
  VoidCallback dismissCallback;
  MenuClickCallback onClickMenu;
  Rect showRect;  // 显示在哪个view的rect
  bool isDown = true; // 是显示在下方还是上方，通过计算得到
  static BuildContext context;

  PopupMenu({MenuClickCallback onClickMenu, BuildContext context, VoidCallback onDismiss, List<MenuItem> items}) {
    this.onClickMenu = onClickMenu;
    this.dismissCallback = onDismiss;
    this.items = items;
    if (context != null) {
      PopupMenu.context = context;
    }
  }

  void show({@required Rect rect, List<MenuItem> items}) {
    this.items = items ?? this.items;
    this.showRect = rect;
    _col = _calculateColCount();
    _row = _calculateRowCount();
    _offset = _calculateOffset(PopupMenu.context);
    this.dismissCallback = dismissCallback;

    _entry = OverlayEntry(builder: (context) {
      return buildPopupMenuLayout(_offset);
    });

    Overlay.of(PopupMenu.context).insert(_entry);
  }

  void dismiss() {
    _entry.remove();
    if (dismissCallback != null) {
      dismissCallback();
    }
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = showRect.left + showRect.width / 2.0 - menuWidth() / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    double dy = showRect.top - menuHeight();
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // 上面放不下，放下面
      dy = arrowHeight + showRect.height + showRect.top;
      isDown = false;
    }

    return Offset(dx, dy);
  }

  double menuWidth() {
    return itemWidth * _col;
  }

  // 这里是没有加上箭头部分高度的
  double menuHeight() {
    return itemHeight * _row;
  }

  LayoutBuilder buildPopupMenuLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismiss();
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: showRect.left + showRect.width / 2.0 - 7.5,
              top: isDown ? offset.dy + menuHeight() : offset.dy - arrowHeight,
              child: CustomPaint(
                size: Size(15.0, arrowHeight),
                painter: TrianglePainter(isDown: isDown),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy,
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
                              color: Color(0xff232323),
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
      );
    });
  }

  // 创建行
  List<Widget> _createRows() {
    List<Widget> rows = [];
    for (int i = 0; i < _row; i++) {
      Color color =
          (i < _row - 1 && _row != 1) ? Color(0xff353535) : Colors.transparent;
      Widget rowWidget = Container(
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(color: color))),
        height: itemHeight,
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
    List<MenuItem> subItems =
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

  // 计算要显示几行
  int _calculateRowCount() {
    if (items == null || items.length == 0) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    int itemCount = items.length;

    if (_calculateColCount() == 1) {
      return 1;
    }

    int row = (itemCount - 1) ~/ _calculateColCount() + 1;

    return row;
  }

  // 要显示多少列
  int _calculateColCount() {
    if (items == null || items.length == 0) {
      debugPrint('error menu items can not be null');
      return 0;
    }

    int itemCount = items.length;

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
    return width/ratio;
  }

  // 最多能显示几列,根据屏幕宽度计算, 一行最多显示4个
  int get _maxColumn => min(4, (screenWidth - 20.0) ~/ itemWidth);

  Widget _createMenuItem(MenuItem item, bool showLine) {
    return _MenuItemWidget(
      item: item,
      showLine: showLine,
      clickCallback: itemClicked,
    );
  }

  void itemClicked(MenuItemProvider item) {
    if (onClickMenu != null) {
      onClickMenu(item);
    }

    dismiss();
  }
}

class _MenuItemWidget extends StatefulWidget {
  final MenuItem item;
  // 是否要显示右边的分隔线
  final bool showLine;
  final Function(MenuItemProvider item) clickCallback;

  _MenuItemWidget({this.item, this.showLine = false, this.clickCallback});

  @override
  State<StatefulWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  final highlightColor = Color(0x55000000);
  var color = Color(0xff232323);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        color = highlightColor;
        setState(() {});
      },
      onTapUp: (details) {
        color = Color(0xff232323);
        setState(() {});
      },
      onLongPressEnd: (details) {
        color = Color(0xff232323);
        setState(() {});
      },
      onTap: () {
        if (widget.clickCallback != null) {
          widget.clickCallback(widget.item);
        }
      },
      child: Container(
        width: PopupMenu.itemWidth,
        height: PopupMenu.itemHeight,
        decoration: BoxDecoration(
            color: color,
            border: Border(
                right: BorderSide(
                    color: widget.showLine
                        ? Color(0xff353535)
                        : Colors.transparent))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30.0,
              height: 30.0,
              child: widget.item.image,
            ),
            Container(
              height: 22.0,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  widget.item.title,
                  style:
                      const TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
