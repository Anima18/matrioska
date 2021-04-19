import 'package:flutter/material.dart';

class KeyboardUtil {
  static void hide(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}