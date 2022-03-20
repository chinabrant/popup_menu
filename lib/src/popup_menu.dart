import 'dart:core';

import 'package:flutter/material.dart';
import 'package:popup_menu/src/grid_menu_layout.dart';
import 'package:popup_menu/src/menu_config.dart';
import 'package:popup_menu/src/utils.dart';
import 'menu_item.dart';

export 'menu_item.dart';
export 'menu_config.dart';

enum MenuType {
  /// 格子
  grid,

  /// 单列
  oneCol
}

typedef MenuClickCallback = Function(MenuItemProvider item);
typedef PopupMenuStateChanged = Function(bool isShow);

class PopupMenu {
  OverlayEntry? _entry;
  late List<MenuItemProvider> items;

  /// callback
  VoidCallback? dismissCallback;
  MenuClickCallback? onClickMenu;
  PopupMenuStateChanged? stateChanged;

  /// Cannot be null
  static late BuildContext context;

  /// It's showing or not.
  bool _isShow = false;
  bool get isShow => _isShow;

  final MenuConfig config;

  PopupMenu({
    this.config = const MenuConfig(),
    MenuClickCallback? onClickMenu,
    required BuildContext context,
    VoidCallback? onDismiss,
    PopupMenuStateChanged? stateChanged,
    required List<MenuItemProvider> items,
  }) {
    this.onClickMenu = onClickMenu;
    this.dismissCallback = onDismiss;
    this.stateChanged = stateChanged;
    this.items = items;
    if (context != null) {
      PopupMenu.context = context;
    }
  }

  GridMenuLayout? gridMenuLayout;

  void show({
    Rect? rect,
    GlobalKey? widgetKey,
    List<MenuItemProvider>? items,
  }) {
    assert(rect != null || widgetKey != null,
        "'rect' and 'key' can't be both null");

    this.items = items ?? this.items;
    final showRect = rect ?? getWidgetGlobalRect(widgetKey!);

    this.dismissCallback = dismissCallback;

    // _calculatePosition(PopupMenu.context);
    gridMenuLayout = GridMenuLayout(
      config: config,
      items: this.items,
      showRect: showRect,
      onDismiss: dismiss,
      context: context,
    );

    _entry = OverlayEntry(builder: (context) {
      return gridMenuLayout!
          .buildPopupMenuLayout(); // buildPopupMenuLayout(_offset);
    });

    Overlay.of(PopupMenu.context)!.insert(_entry!);
    _isShow = true;
    if (this.stateChanged != null) {
      this.stateChanged!(true);
    }
  }

  void dismiss() {
    if (!_isShow) {
      // Remove method should only be called once
      return;
    }

    _entry?.remove();
    _isShow = false;
    if (dismissCallback != null) {
      dismissCallback!();
    }

    if (this.stateChanged != null) {
      this.stateChanged!(false);
    }
  }
}
