import 'package:flutter/material.dart';
import 'package:rasooc/presentation/pages/splash.dart';

class Routes {
  Routes._internal();
  static dynamic route() {
    return {
      '/': (BuildContext context) => Splash(),
    };
  }

  static void sendNavigationEventToFirebase(String path) {
    if (path.isNotEmpty) {
      // analytics.setCurrentScreen(screenName: path);
    }
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name!.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      //TODO: ADD ROUTES HERE

      default:
        return onUnknownRoute(
          const RouteSettings(name: 'Feature'),
        );
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(settings.name!),
          centerTitle: true,
        ),
        body: Center(
          child: Text('${settings.name!.split('/')[1]} Comming soon..'),
        ),
      ),
    );
  }
}
