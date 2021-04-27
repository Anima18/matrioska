import 'package:flutter/material.dart';
import 'constant.dart' as constant;

typedef ScrollListener = Function(double offset);

class SearchPanelButton extends StatelessWidget {

  final String title;
  final VoidCallback onPressed;
  SearchPanelButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onPressed();
        },
        child:Container(
          padding: constant.searchBarButtonPadding,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              //设置四周边框
              border: new Border.all(width: 1, color: Colors.grey)),
          child: Text(title),
        )
    );
  }
}