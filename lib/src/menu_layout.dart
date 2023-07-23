import 'package:flutter/material.dart';

abstract class MenuLayout {
  /// 菜单的宽度
  double get width;

  /// 菜单的高度，不包含箭头
  double get height;

  /// 创建菜单内容，不包含箭头
  Widget build();
}
