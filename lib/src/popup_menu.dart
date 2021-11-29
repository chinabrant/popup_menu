// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'menu_layout.dart';
import 'popup_menu_action.dart';

/// PopupMenu class for display menu.
class PopupMenu extends MenuLayout {
  /// Popup Menu actions. [PopupAction].
  /// can not be empty or null
  final List<PopupAction> menuActions;

  /// OnClick menu items
  ///
  /// return items [int] index [MenuController] menu.
  /// menu [MenuController] for the close menu box.
  /// index [int] for which item onClick.
  @override
  final Function(int index, MenuController menu) onPress;

  /// Maximum column length
  /// Default value is 4
  final int maxRowItemLength;

  /// Decoration menu box.
  /// default,
  /// "BoxDecoration(color:Colors.red,borderRadius:BorderRadius.circular(10.0))"
  final BoxDecoration? boxDecoration;

  /// Behind of menu box color.
  final Color? color;

  /// [Offset] of menu box.
  /// where you want it to be.
  final Offset? offsetBox;

  /// Animation builder.
  /// You must give the following [PopupAction] actions to the child part:
  /// You can put any animation.
  final MenuActionsBuilder? builder;

  /// Animation duration
  final Duration? duration;

  /// [Animation] reverse duration.
  final Duration? reverseDuration;

  /// Main axis spacing.
  final double mainAxisSpacing;

  /// Cros axis spacing.
  final double crossAxisSpacing;

  /// Item width.
  final double itemWidth;

  /// Item height
  final double itemHeight;

  /// this [popup_menu] show queue
  /// default true.
  final bool showQueue;

  PopupMenu(
    BuildContext context,
    Key key, {
    required this.menuActions,
    required this.onPress,
    this.maxRowItemLength = 1,
    this.boxDecoration,
    this.offsetBox,
    this.color,
    this.builder,
    this.duration,
    this.reverseDuration,
    this.mainAxisSpacing = 10.0,
    this.crossAxisSpacing = 10.0,
    this.itemWidth = 50.0,
    this.itemHeight = 50.0,
    this.showQueue = true,
  })  : assert(boxDecoration == null || boxDecoration.debugAssertIsValid()),
        assert(menuActions.isNotEmpty, 'Actions cannot be empty'),
        assert(
          boxDecoration == null || color == null,
          'Cannot provide both a color and decoration\n'
          'The color argument is just a shorthand for "decoration: BoxDecoration(color:color)".',
        ),
        super(
          context,
          key,
          actions: menuActions,
          onPress: onPress,
          menuBuilder: builder,
          duration: duration,
          reverseDuration: reverseDuration,
          width: itemWidth,
          height: itemHeight,
          maxRow: maxRowItemLength,
          decoration:
              boxDecoration ?? BoxDecoration(color: color ?? Colors.white),
          offset: offsetBox,
          crossSpace: crossAxisSpacing,
          mainSpace: mainAxisSpacing,
          showQueue: showQueue,
        );
}
