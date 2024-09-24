import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:popup_menu/src/menu_layout.dart';

import 'menu_item_widget.dart';

/// Grid menu layout
class GridMenuLayout implements MenuLayout {
  final MenuConfig config;
  final List<MenuItemProvider> items;
  final VoidCallback onDismiss;
  final BuildContext context;
  final MenuClickCallback? onClickMenu;

  GridMenuLayout({
    required this.config,
    required this.items,
    required this.onDismiss,
    required this.context,
    this.onClickMenu,
  }) {
    _calculateRowAndCol();
  }

  /// row count
  int _row = 1;

  /// col count
  int _col = 1;

  /// calculate the menu row and col count
  void _calculateRowAndCol() {
    _col = _calculateColCount();
    _row = _calculateRowCount();
  }

  double menuWidth() {
    return config.itemWidth * _col;
  }

  // This height exclude the arrow
  double menuHeight() {
    return config.itemHeight * _row;
  }

  int menuMaxColumn() {
    return config.maxColumn;
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
        // width: config.itemWidth,
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
    if (menuMaxColumn() != 4 && menuMaxColumn() > 0) {
      return menuMaxColumn();
    }

    if (itemCount == 4) {
      // 4个显示成两行
      return 2;
    }

    if (itemCount <= menuMaxColumn()) {
      return itemCount;
    }

    if (itemCount == 5) {
      return 3;
    }

    if (itemCount == 6) {
      return 3;
    }

    return menuMaxColumn();
  }

  double get screenWidth {
    double width = window.physicalSize.width;
    double ratio = window.devicePixelRatio;
    return width / ratio;
  }

  Widget _createMenuItem(MenuItemProvider item, bool showLine) {
    return MenuItemWidget(
      menuConfig: config,
      item: item,
      showLine: showLine,
      clickCallback: itemClicked,
    );
  }

  void itemClicked(MenuItemProvider item) {
    onClickMenu?.call(item);
    onDismiss();
  }

  @override
  Widget build() {
    return Container(
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
    );
  }

  @override
  double get height => menuHeight();

  @override
  double get width => menuWidth();
}
