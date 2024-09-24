import 'package:flutter/material.dart';
import 'package:popup_menu/src/popup_menu.dart';

import 'menu_item.dart';

class MenuItemWidget extends StatefulWidget {
  final MenuItemProvider item;
  final MenuConfig menuConfig;
  // 是否要显示右边的分隔线
  final bool showLine;

  final Function(MenuItemProvider item)? clickCallback;

  MenuItemWidget({
    required this.menuConfig,
    required this.item,
    this.showLine = false,
    this.clickCallback,
  });

  @override
  State<StatefulWidget> createState() {
    return _MenuItemWidgetState();
  }
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  var highlightColor = Color(0x55000000);
  var color = Color(0xff232323);

  @override
  void initState() {
    color = widget.menuConfig.backgroundColor;
    highlightColor = widget.menuConfig.highlightColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        color = highlightColor;
        setState(() {});
      },
      onTapUp: (details) {
        color = widget.menuConfig.backgroundColor;
        setState(() {});
      },
      onLongPressEnd: (details) {
        color = widget.menuConfig.backgroundColor;
        setState(() {});
      },
      onTap: () {
        if (widget.clickCallback != null) {
          widget.clickCallback!(widget.item);
        }
      },
      child: Container(
          width: widget.menuConfig.itemWidth,
          height: widget.menuConfig.itemHeight,
          decoration: BoxDecoration(
              color: color,
              border: Border(
                  right: BorderSide(
                      color: widget.showLine
                          ? widget.menuConfig.lineColor
                          : Colors.transparent))),
          child: _createContent()),
    );
  }

  Widget _createContent() {
    if (widget.item.menuImage != null) {
      // image and text
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 30.0,
            height: 30.0,
            child: widget.item.menuImage,
          ),
          Container(
            height: 22.0,
            child: Material(
              color: Colors.transparent,
              child: Text(
                widget.item.menuTitle,
                style: widget.item.menuTextStyle ?? widget.menuConfig.textStyle,
              ),
            ),
          )
        ],
      );
    } else {
      // only text
      return Container(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Text(
              widget.item.menuTitle,
              style: widget.item.menuTextStyle ?? widget.menuConfig.textStyle,
              textAlign:
                  widget.item.menuTextAlign ?? widget.menuConfig.textAlign,
            ),
          ),
        ),
      );
    }
  }
}
