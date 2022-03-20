import 'package:flutter/material.dart';

Rect getWidgetGlobalRect(GlobalKey key) {
  assert(key.currentContext != null, '');

  RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
  var offset = renderBox.localToGlobal(Offset.zero);
  return Rect.fromLTWH(
      offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
}
