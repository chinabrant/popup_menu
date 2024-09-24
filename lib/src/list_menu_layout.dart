import 'package:flutter/material.dart';
import 'package:popup_menu/src/menu_layout.dart';

import 'menu_config.dart';
import 'menu_item.dart';
import 'popup_menu.dart';

/// list menu layout
class ListMenuLayout implements MenuLayout {
  final MenuConfig config;
  final List<MenuItemProvider> items;
  final VoidCallback onDismiss;
  final BuildContext context;
  final MenuClickCallback? onClickMenu;

  ListMenuLayout({
    required this.config,
    required this.items,
    required this.onDismiss,
    required this.context,
    this.onClickMenu,
  });

  @override
  Widget build() {
    return Container(
      width: width,
      height: height,
      child: Column(
        children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    color: config.backgroundColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: items.map((item) {
                    return GestureDetector(
                      onTap: () {
                        onDismiss();
                        onClickMenu?.call(item);
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        height: config.itemHeight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: item.menuImage,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                item.menuTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: item.menuTextStyle ?? config.textStyle,
                                textAlign: item.menuTextAlign,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
        ],
      ),
    );
  }

  @override
  double get height => config.itemHeight * items.length;

  @override
  double get width => config.itemWidth;
}
