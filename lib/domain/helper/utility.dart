import 'dart:io';
import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utility {
  Utility._();

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static void displaySnackbar(BuildContext context,
      {String msg = "Feature is under development",
      GlobalKey<ScaffoldMessengerState>? key}) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    );
    if (key != null && key.currentState != null) {
      key.currentState!.hideCurrentSnackBar();
      key.currentState!.showSnackBar(snackBar);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    final i = (log(bytes) / log(1024)).floor();
    return "${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  static int connectionCode = 1;

  // Platform messages are asynchronous, so we initialize in an async method.
  static Future<void> initConnectivity(Connectivity connectivity,
      {bool mounted = true}) async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return updateConnectionStatus(result);
  }

  static Future<void> updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        connectionCode = 1;
        break;
      case ConnectivityResult.none:
        connectionCode = 0;
        break;
      default:
        connectionCode = 0;
        break;
    }
  }
}
