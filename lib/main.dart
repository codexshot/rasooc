
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rasooc/app.dart';
import 'package:rasooc/domain/helper/config.dart';
import 'package:rasooc/domain/helper/configs.dart';
import 'package:rasooc/locator.dart';
import 'package:rasooc/presentation/pages/splash.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final HttpClient client = super.createHttpClient(context); //<<--- notice 'super'
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() {
  ///`releaseConfig` targets the production DB
  ///`devConfig` is for developement
  final config = releaseConfig(); //TODO: CHANGE CONFIG ACCORDING TO MODES

  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  setUpDependency(config);
  final configuredApp = AppConfig(
    config: config,
    child: RasoocApp(home: Splash()),
  );

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then(
    (_) => runApp(configuredApp),
  );
}
