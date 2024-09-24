import 'package:flutter/material.dart';
import 'package:popup_menu/src/popup_menu.dart';

/// 菜单配置
class MenuConfig {
  /// 菜单类型
  final MenuType type;

  /// 菜单的宽度
  final double itemWidth;

  /// 菜单项的高度
  final double itemHeight;

  /// 箭头的高度
  final double arrowHeight;

  /// Maximum number of columns for grid-type menu.
  final int maxColumn;

  /// 背景色
  final Color backgroundColor;

  /// The highlight color on click.
  final Color highlightColor;

  /// The color of the separator line.
  final Color lineColor;

  /// Uniformly setting the TextStyle for MenuItem will be overridden by MenuItem;
  /// if MenuItem does not set it, then this Style will be used.
  final TextStyle textStyle;

  /// Text alignment, only effective in List Menu.
  final TextAlign textAlign;

  const MenuConfig({
    this.type = MenuType.grid,
    this.itemWidth = 72.0,
    this.itemHeight = 65.0,
    this.arrowHeight = 10.0,
    this.maxColumn = 4,
    this.backgroundColor = const Color(0xff232323),
    this.highlightColor = const Color(0xff353535),
    this.lineColor = const Color(0x55000000),
    this.textStyle = const TextStyle(
      color: Color(0xffc5c5c5),
      fontSize: 10.0,
    ),
    this.textAlign = TextAlign.center,
  });

  factory MenuConfig.forList({
    double itemWidth = 120.0,
    double itemHeight = 40.0,
    double arrowHeight = 10.0,
    Color backgroundColor = Colors.white,
    Color highlightColor = const Color(0xff353535),
    Color lineColor = const Color(0x55000000),
  }) {
    return MenuConfig(
      type: MenuType.list,
      itemWidth: itemWidth,
      itemHeight: itemHeight,
      arrowHeight: arrowHeight,
      backgroundColor: backgroundColor,
      highlightColor: highlightColor,
      lineColor: lineColor,
    );
  }
}
