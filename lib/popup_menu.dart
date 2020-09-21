library popup_menu;

import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'triangle_painter.dart';

abstract class MenuItemProvider {
  String get menuTitle;

  Widget get menuImage;

  Size get menuImageSize;

  TextStyle get menuTextStyle;

  TextAlign get menuTextAlign;
}

class MenuItem extends MenuItemProvider {
  Widget image; // 图标名称
  String title; // 菜单标题
  var userInfo; // 额外的菜单荐信息
  TextStyle textStyle;
  TextAlign textAlign;
  Size imageSize;

  MenuItem(
      {this.title, this.image, this.userInfo, this.textStyle, this.textAlign,this.imageSize});

  @override
  Widget get menuImage => image;

  @override
  String get menuTitle => title;

  @override
  TextStyle get menuTextStyle =>
      textStyle ?? TextStyle(color: Color(0xffc5c5c5), fontSize: 10.0);

  @override
  TextAlign get menuTextAlign => textAlign ?? TextAlign.center;

  @override
  Size get menuImageSize => imageSize ?? Size(30.0,30.0);
}

enum MenuType { big, oneLine }

typedef MenuClickCallback = Function(MenuItemProvider item);
typedef PopupMenuStateChanged = Function(bool isShow);

const double defaultItemWidth = 72.0;
const double defaultItemHeight = 65.0;
const double defaultArrowHeight = 10.0;

class PopupMenu {
  OverlayEntry _entry;
  List<MenuItemProvider> items;

  /// row count
  int _row;

  /// col count
  int _col;

  /// The left top point of this menu.
  Offset _offset;

  /// Menu will show at above or under this rect
  Rect _showRect;

  /// if false menu is show above of the widget, otherwise menu is show under the widget
  bool _isDown = true;

  /// The max column count, default is 4.
  int _maxColumn;

  /// callback
  VoidCallback dismissCallback;
  MenuClickCallback onClickMenu;
  PopupMenuStateChanged stateChanged;

  Size _screenSize; // 屏幕的尺寸

  /// Cannot be null
  static BuildContext context;

  /// style
  Color get _backgroundColor => menuTheme.backgroundColor;

  Color get _highlightColor => menuTheme.highlightColor;

  Color get _lineColor => menuTheme.lineColor;

  MenuType get menuType => menuTheme.menuType;

  double get arrowHeight => menuTheme.arrowHeight;

  double get itemWidth => menuTheme.itemSize.width;

  double get itemHeight => menuTheme.itemSize.height;

  /// It's showing or not.
  bool _isShow = false;

  bool get isShow => _isShow;

  MenuTheme menuTheme;

  PopupMenu(
      {MenuClickCallback onClickMenu,
      BuildContext context,
      VoidCallback onDismiss,
      int maxColumn,
      MenuTheme menuTheme,
      PopupMenuStateChanged stateChanged,
      List<MenuItemProvider> items}) {
    this.onClickMenu = onClickMenu;
    this.dismissCallback = onDismiss;
    this.stateChanged = stateChanged;
    this.items = items;
    this.menuTheme = menuTheme ?? MenuTheme();
    this._maxColumn = maxColumn ?? 4;
    if (context != null) {
      PopupMenu.context = context;
    }
  }

  void show({Rect rect, GlobalKey widgetKey, List<MenuItemProvider> items}) {
    if (rect == null && widgetKey == null) {
      print("'rect' and 'key' can't be both null");
      return;
    }

    this.items = items ?? this.items;
    this._showRect = rect ?? PopupMenu.getWidgetGlobalRect(widgetKey);
    this._screenSize = window.physicalSize / window.devicePixelRatio;
    this.dismissCallback = dismissCallback;

    _calculatePosition(PopupMenu.context);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupMenuLayout(_offset);
    });

    Overlay.of(PopupMenu.context).insert(_entry);
    _isShow = true;
    if (this.stateChanged != null) {
      this.stateChanged(true);
    }
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void _calculatePosition(BuildContext context) {
    _col = _calculateColCount();
    _row = _calculateRowCount();
    _offset = _calculateOffset(PopupMenu.context);
  }

  Offset _calculateOffset(BuildContext context) {
    /// 中点
    double dx = _showRect.left + _showRect.width / 2.0 - menuWidth() / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx + menuWidth() > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - menuWidth() - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - menuHeight();
    if (dy <= MediaQuery.of(context).padding.top + 10) {
      // The have not enough space above, show menu under the widget.
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isDown = false;
    } else {
      dy -= arrowHeight;
      _isDown = true;
    }

    return Offset(dx, dy);
  }

  double menuWidth() {
    return itemWidth * _col;
  }

  // This height exclude the arrow
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
//        onTapDown: (TapDownDetails details) {
//          dismiss();
//        },
        // onPanStart: (DragStartDetails details) {
        //   dismiss();
        // },
        onVerticalDragStart: (DragStartDetails details) {
          dismiss();
        },
        onHorizontalDragStart: (DragStartDetails details) {
          dismiss();
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              // triangle arrow
              Positioned(
                left: _showRect.left + _showRect.width / 2.0 - 7.5,
                top: _isDown
                    ? offset.dy + menuHeight()
                    : offset.dy - arrowHeight,
                child: CustomPaint(
                  size: Size(15.0, arrowHeight),
                  painter:
                      TrianglePainter(isDown: _isDown, color: _backgroundColor),
                ),
              ),
              // menu content
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
                                color: _backgroundColor,
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
          (i < _row - 1 && _row != 1) ? _lineColor : Colors.transparent;
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
    if (items == null || items.length == 0) {
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
    if (items == null || items.length == 0) {
      debugPrint('error menu items can not be null');
      return 0;
    }

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
    return _MenuItemWidget(
        item: item,
        showLine: showLine,
        clickCallback: itemClicked,
        menuTheme: menuTheme);
  }

  void itemClicked(MenuItemProvider item) {
    if (onClickMenu != null) {
      onClickMenu(item);
    }

    dismiss();
  }

  void dismiss() {
    if (!_isShow) {
      // Remove method should only be called once
      return;
    }

    _entry.remove();
    _isShow = false;
    if (dismissCallback != null) {
      dismissCallback();
    }

    if (this.stateChanged != null) {
      this.stateChanged(false);
    }
  }
}

class _MenuItemWidget extends StatefulWidget {
  final MenuItemProvider item;

  // 是否要显示右边的分隔线
  final bool showLine;
  final MenuTheme menuTheme;

  final Function(MenuItemProvider item) clickCallback;

  _MenuItemWidget(
      {this.item, this.showLine = false, this.clickCallback, this.menuTheme});

  @override
  State<StatefulWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  Color get highlightColor => widget.menuTheme.highlightColor;

  Color get backgroundColor => widget.menuTheme.backgroundColor;

  Color get lineColor => widget.menuTheme.lineColor;

  MenuType get menuType => widget.menuTheme.menuType;

  double get itemWidth => widget.menuTheme.itemSize.width;

  double get itemHeight => widget.menuTheme.itemSize.height;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Border border;
    Widget child;
    Color color;
    switch (menuType) {
      case MenuType.big:
        border = Border(
            right: BorderSide(
                color: widget.showLine ? lineColor : Colors.transparent));
        child = _createBigContent();
        break;
      case MenuType.oneLine:
        border = Border(
            bottom: BorderSide(
                color: widget.showLine ? lineColor : Colors.transparent));
        child = _createLineContent();
        break;
    }

    return GestureDetector(
      onTapDown: (details) {
        color = highlightColor;
        setState(() {});
      },
      onTapUp: (details) {
        color = backgroundColor;
        setState(() {});
      },
      onLongPressEnd: (details) {
        color = backgroundColor;
        setState(() {});
      },
      onTap: () {
        if (widget.clickCallback != null) {
          widget.clickCallback(widget.item);
        }
      },
      child: Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(color: color, border: border),
          child: child),
    );
  }

  Widget _createBigContent() {
    if (widget.item.menuImage != null) {
      // image and text
      return _createBigItem();
    } else {
      // only text
      return _createText();
    }
  }

  Widget _createLineContent() {
    if (widget.item.menuImage != null) {
      return _createLineItem();
    } else {
      return _createText();
    }
  }

  Widget _createLineItem() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: <Widget>[
        _createText(),
        Spacer(),
        widget.item.menuImage
      ]),
    );
  }

  Widget _createBigItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: widget.item.menuImageSize.width,
          height: widget.item.menuImageSize.height,
          child: widget.item.menuImage,
        ),
        _createText()
      ],
    );
  }

  Widget _createText() {
    return Container(
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Text(
            widget.item.menuTitle,
            style: widget.item.menuTextStyle,
            textAlign: widget.item.menuTextAlign,
          ),
        ),
      ),
    );
  }
}

class MenuTheme {
  final Size itemSize;
  final Color highlightColor;
  final Color backgroundColor;
  final Color lineColor;
  final MenuType menuType;
  final double arrowHeight;

  MenuTheme(
      {this.arrowHeight = defaultArrowHeight,
      this.itemSize = const Size(defaultItemWidth, defaultItemHeight),
      this.highlightColor = const Color(0x55000000),
      this.backgroundColor = const Color(0xff232323),
      this.lineColor = const Color(0xff353535),
      this.menuType = MenuType.big});
}
