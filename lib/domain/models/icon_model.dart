import 'package:flutter/material.dart';

class IconModel {
  final String? title;
  final IconData? iconData;
  final Function? onPressed;

  IconModel({
    this.title,
    this.iconData,
    this.onPressed,
  });
}

class PlatformIconModel {
  final String? title;
  final String? imagepathSvg;
  final Function? onPressed;

  PlatformIconModel({
    this.title,
    this.imagepathSvg,
    this.onPressed,
  });
}
