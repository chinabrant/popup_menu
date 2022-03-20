import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

abstract class MenuLayout {
  /// 菜单项
  List<MenuItem> get items;

  /// 显示区域
  Rect get showRect;

  MenuConfig get config;

  // 计算布局
  void layout();

  Widget createContent();
}
