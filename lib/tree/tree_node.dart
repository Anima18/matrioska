import 'package:flutter/material.dart';

import 'tree_data.dart';

typedef OnTreeItemClick = void Function(TreeData treeData);

class TreeNode extends StatefulWidget {
  final int level;
  final bool expaned;
  final double offsetLeft;
  final List<Widget> children;

  final TreeData data;
  final IconButton? leadingIcon;
  final IconButton? childIcon;
  final IconButton trailing;

  final OnTreeItemClick? titleOnTap;
  final Function? leadingOnTap;
  final Function? trailingOnTap;

  const TreeNode({
    required this.data,
    this.level = 0,
    this.expaned = false,
    this.offsetLeft = 24.0,
    this.children = const [],
    this.childIcon,
    this.leadingIcon,
    this.trailing = const IconButton(
      icon: Icon(Icons.expand_more),
      iconSize: 18,
      onPressed: null,
    ),
    this.titleOnTap,
    this.leadingOnTap,
    this.trailingOnTap,
  });

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  bool _isExpaned = false;

  late AnimationController _rotationController;
  final Tween<double> _turnsTween = Tween<double>(begin: 0.0, end: -0.5);

  initState() {
    _isExpaned = widget.expaned;
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final level = widget.level;
    final children = widget.children;
    final offsetLeft = widget.offsetLeft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: InkWell(
            onTap: () {
              if (widget.titleOnTap != null && widget.titleOnTap is OnTreeItemClick) {
                widget.titleOnTap!(widget.data);
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                    visible: children.length == 0,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.leadingOnTap != null &&
                            widget.leadingOnTap is Function) {
                          widget.leadingOnTap!();
                        }
                      },
                      child: Center(
                        child: widget.childIcon ?? SizedBox(width:  widget.leadingIcon!.iconSize ,),
                      ),
                    ),
                ),
                Visibility(
                  visible: children.length > 0,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.leadingOnTap != null &&
                          widget.leadingOnTap is Function) {
                        widget.leadingOnTap!();
                      }
                    },
                    child: Center(
                      child: widget.leadingIcon ??
                          const IconButton(
                            icon: Icon(Icons.star_border),
                            iconSize: 16,
                            onPressed: null,
                          ),
                    ),
                  ),
                ),

                SizedBox(width: 6.0),
                Expanded(
                  child: Container(
                    height: 36,
                    alignment: Alignment.centerLeft,
                    child: Text(widget.data.title,
                      style: TextStyle(
                        color: widget.data.selected ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.0),
                Visibility(
                  visible: children.length > 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpaned = !_isExpaned;
                          if (_isExpaned) {
                            _rotationController.forward();
                          } else {
                            _rotationController.reverse();
                          }
                          widget.data.expanded = _isExpaned;
                          if (widget.trailingOnTap != null &&
                              widget.trailingOnTap is Function) {
                            widget.trailingOnTap!();
                          }
                        });
                      },
                      child: RotationTransition(
                        child: widget.trailing, /*??
                            const IconButton(
                              icon: Icon(Icons.expand_more),
                              iconSize: 16,
                              onPressed: null,
                            ),*/
                        turns: _turnsTween.animate(_rotationController),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: children.length > 0 && _isExpaned,
          child: Padding(
            padding: EdgeInsets.only(left: level + 1 * offsetLeft),
            child: Column(
              children: widget.children,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
      ],
    );
  }
}
