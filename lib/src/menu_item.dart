import 'package:flutter/material.dart';

abstract class MenuItemProvider {
  String get menuTitle;
  dynamic get menuUserInfo;
  Widget? get menuImage;
  TextStyle get menuTextStyle;
  TextAlign get menuTextAlign;
}

/// Default menu item
class MenuItem extends MenuItemProvider {
  Widget? image;
  String title;
  var userInfo; // 额外的菜单荐信息
  TextStyle textStyle;
  TextAlign textAlign;

  MenuItem({
    this.title = "",
    this.image,
    this.userInfo,
    this.textStyle = const TextStyle(
      color: Color(0xffc5c5c5),
      fontSize: 10.0,
    ),
    this.textAlign = TextAlign.center,
  });

  @override
  Widget? get menuImage => image;

  @override
  String get menuTitle => title;

  @override
  dynamic get menuUserInfo => userInfo;

  @override
  TextStyle get menuTextStyle => textStyle;

  @override
  TextAlign get menuTextAlign => textAlign;
}
