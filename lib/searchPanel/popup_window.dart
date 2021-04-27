import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'menuView/menu_view.dart';

const int _windowPopupDuration = 300;
const double _kWindowCloseIntervalEnd = 2.0 / 3.0;
const Duration _kWindowDuration = Duration(milliseconds: _windowPopupDuration);

class PopupWindowButton<T> extends StatefulWidget {
  const PopupWindowButton({
    Key? key,
    this.child,
    this.window,
    this.offset = Offset.zero,
    this.elevation = 6.0,
    this.duration = 100,
    this.type = MaterialType.card,
  }) : super(key: key);

  /// 显示按钮button
  final Widget? child;

  /// window 出现的位置。
  final Offset offset;

  /// 阴影
  final double elevation;

  /// 需要显示的window
  final MenuView? window;

  /// 按钮按钮后到显示window 出现的时间
  final int duration;

  final MaterialType type;

  @override
  _PopupWindowButtonState createState() {
    return _PopupWindowButtonState();
  }
}

void showWindow<T>({
  required BuildContext context,
  RelativeRect? position,
  required Widget? window,
  double elevation = 6.0,
  int duration = _windowPopupDuration,
  String? semanticLabel,
  MaterialType? type,
}) {
  Navigator.push(
    context,
    _PopupWindowRoute<T>(
        position: position,
        child: window as MenuView?,
        elevation: elevation,
        duration: duration,
        semanticLabel: semanticLabel,
        barrierLabel:
        MaterialLocalizations.of(context).modalBarrierDismissLabel,
        type: type),
  );
}

class _PopupWindowButtonState<T> extends State<PopupWindowButton> {
  void _showWindow() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showWindow<T>(
        context: context,
        window: widget.window,
        position: position,
        duration: widget.duration,
        elevation: widget.elevation,
        type: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: InkWell(
      onTap: _showWindow,
      child: widget.child,
    ));
  }
}

class _PopupWindowRoute<T> extends PopupRoute<T> {
  _PopupWindowRoute({
    this.position,
    this.child,
    this.elevation,
    this.theme,
    this.barrierLabel,
    this.semanticLabel,
    this.duration,
    this.type = MaterialType.card,
  });

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.linear,
        reverseCurve: const Interval(0.0, _kWindowCloseIntervalEnd));
  }

  final RelativeRect? position;
  final MenuView? child;
  final double? elevation;
  final ThemeData? theme;
  final String? semanticLabel;
  @override
  final String? barrierLabel;
  final int? duration;
  final MaterialType? type;

  @override
  Duration get transitionDuration =>
      duration == 0 ? _kWindowDuration : Duration(milliseconds: duration!);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;


  @override
  TickerFuture didPush() {
    print("didPush");
    child!.onShow();
    return super.didPush();
  }


  @override
  Future<RoutePopDisposition> willPop() {
    print("willPop");
    child!.onDismiss();
    return super.willPop();
  }
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final curvedValue = Curves.fastOutSlowIn.transform(animation.value) - 1;
    return Transform(
      transform: Matrix4.translationValues(0.0, curvedValue * 20, 0.0),
      child: Opacity(
        opacity: animation.value,
        child: child,
      ),
    );
    /*return SlideTransition(
           position: Tween<Offset>(
             // 设置滑动的 X , Y 轴
             begin: Offset(0, -0.1),
             end: Offset.zero
           ).animate(CurvedAnimation(
             parent: animation,
             curve: Curves.fastOutSlowIn
           )),
           child: child,
         );*/
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final CurveTween opacity =
    CurveTween(curve: const Interval(0.0, 1.0 / 3.0));

    return Builder(
      builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: _PopupWindowLayout(position),
          child: AnimatedBuilder(
              child: child,
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Opacity(
                  opacity: opacity.evaluate(animation),
                  child: Material(
                    type: type!,
                    elevation: elevation!,
                    child: child,
                  ),
                );
              }),
        );
      },
    );
  }
}

class _PopupWindowLayout extends SingleChildLayoutDelegate {
  _PopupWindowLayout(this.position);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect? position;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y = position!.top;

    // Find the ideal horizontal position.
    double x = 0;
    /*if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    }*/
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupWindowLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}