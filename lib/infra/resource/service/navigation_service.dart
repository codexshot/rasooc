import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(Widget pageName) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => pageName), (route) => false);
  }
}
