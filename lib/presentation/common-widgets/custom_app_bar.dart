import 'package:flutter/material.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';

class RAppBar extends StatelessWidget {
  final String? title;
  final bool centerTitle;
  final double elevation;

  const RAppBar({
    Key? key,
    this.title,
    this.centerTitle = false,
    this.elevation = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: RText(
        title!,
        variant: TypographyVariant.h1,
      ),
      centerTitle: centerTitle,
    );
  }
}
