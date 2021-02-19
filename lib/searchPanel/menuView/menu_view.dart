import 'package:flutter/cupertino.dart';

abstract class MenuView extends StatefulWidget {
  void setText(String text);
  void setValue(String value);
  void onShow();
  void onDismiss();
  void onSearch();
}