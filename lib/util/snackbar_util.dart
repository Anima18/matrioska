import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarUtil {
  static show(BuildContext context, String message, {Function () dismissCallback}) {
    var snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    );
    WidgetsBinding.instance.addPostFrameCallback((_){
      ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((value) {
        if(dismissCallback != null) {
          dismissCallback();
        }
      });
    });
  }
}