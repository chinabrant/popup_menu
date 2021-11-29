import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Abstract class for popup menu items actions click.
abstract class PopupMenuActions extends StatelessWidget {
  /// Constructor [PopupMenuActions]
  const PopupMenuActions({
    Key? key,
    this.color,
  }) : super(key: key);

  /// The background color of this actions.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: builder(context),
    );
  }

  /// Builds the action.
  @protected
  Widget builder(BuildContext context);
}

/// A basic popup menu action with a background color and a child that will
/// be center inside its area.
class PopupAction extends PopupMenuActions {
  PopupAction({
    Key? key,
    required this.item,
    this.title,
    TextStyle? style,
    Color? color,
    BoxDecoration? decoration,
  })  : assert(decoration == null || decoration.debugAssertIsValid()),
        assert(
          color == null || decoration == null,
          'Cannot provide both a color and decoration\n'
          'The color argument is just a shorthand for "decoration: BoxDecoration(color:backgroundColor)".',
        ),
        assert(
          style == null || title != null,
          'If style is not null add a title for actions widget.',
        ),
        style = style ??
            const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              overflow: TextOverflow.ellipsis,
            ),
        decoration =
            decoration ?? (color != null ? BoxDecoration(color: color) : null),
        super(
          key: key,
          color: color ?? Colors.transparent,
        );

  /// Column title under the [item].
  final String? title;

  /// Style of title.
  final TextStyle style;

  /// Popup menu item. [Widget].
  final Widget item;

  /// The decoration to paint behind the [item]
  final BoxDecoration? decoration;

  @override
  Widget builder(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(Flexible(child: item));
    if (title != null) {
      widgets.add(
        Flexible(
          child: Text(
            title!,
            style: style,
          ),
        ),
      );
    }
    return Container(
      decoration: decoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      ),
    );
  }
}
