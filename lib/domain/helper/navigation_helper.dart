import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationHelpers {
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => page));
  }

  static void pushRelacement(BuildContext context, Widget page) {
    Navigator.of(context)
        .pushReplacement(CupertinoPageRoute(builder: (context) => page));
  }

  static void pushRemoveUntil(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => page), (route) => false);
  }
}
