import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'menuView/menu_view.dart';
import 'menuView/menu_view_factory.dart';
import 'menu_item.dart';
import 'popup_window.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';

typedef SearchCallback = void Function(List<MenuItem> menuItems);

abstract class SearchBarCallback {
  void hidden(MenuItem menuItem);
  void expanded(MenuItem menuItem);
  void search(MenuItem menuItem);
}

class SearchBar extends StatefulWidget {

  final List<MenuItem> children;
  final double height;
  final SearchCallback onSearch;
  final Color activeColor;
  SearchBar({this.height, this.children, this.onSearch, this.activeColor=Colors.blue});

  @override
  _SearchBarState createState() {
    return _SearchBarState();
  }
}

class _SearchBarState extends State<SearchBar> implements SearchBarCallback {
  Map<String, MenuView> menuViewMap = Map();


  @override
  Widget build(BuildContext context) {
    List<PopupWindowButton> popupList = List();
    widget.children.forEach((element) {

      var offset = Offset(0, 10000);
      var child = MenuTitle(menuItem:element);
      var window = MenuViewFactory.of(element, this, widget.activeColor);
      menuViewMap[element.code] = window;
      popupList.add(PopupWindowButton(offset: offset, child: child, window: window,));
    });
    return Provider.value(
        value: widget.activeColor,
        child: Container(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: popupList,
          ),
        ),
    );
  }

  @override
  void search(MenuItem menuItem) {
    print("search");
    List<MenuItem> selected = widget.children.where((element) => element.valueList.isNotEmpty ).toList();
    widget.onSearch(selected);
  }

  @override
  void expanded(MenuItem menuItem) {
    print("select");
    setState(() {
      menuItem.selected = true;
    });
  }

  @override
  void hidden(MenuItem menuItem) {
    print("unSelect");
    setState(() {
      menuItem.selected = false;
    });
  }

}

class MenuTitle extends StatefulWidget {
  final MenuItem menuItem;
  const MenuTitle({
    Key key,
    this.menuItem,
  }) : super(key: key);

  @override
  State<MenuTitle> createState() {
    return MenuTitleState();
  }
}

class MenuTitleState extends State<MenuTitle> {

  @override
  Widget build(BuildContext context) {
    Color activeColor = context.read<Color>();
    return Container(
        height: 48,
        alignment: Alignment.center,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                  maxWidth: 70
              ),
              child: Text(
                widget.menuItem.text.isNotEmpty ? widget.menuItem.text : widget.menuItem.name,
                style: TextStyle(fontSize: 14.0, color: (widget.menuItem.selected || widget.menuItem.text.isNotEmpty)  ? activeColor : Colors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Transform.rotate(
              angle: widget.menuItem.selected ? math.pi : 0,
            child: Image(
              width: 18,
              height: 18,
              image: AssetImage("assets/ic_arrow_drop_down.png", package: "matrioska"),
              color: (widget.menuItem.selected || widget.menuItem.text.isNotEmpty) ? activeColor : Colors.black,
            ),)

          ],
        )
    );
  }
}