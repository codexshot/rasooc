import 'package:flutter/material.dart';

class RIcon extends StatelessWidget {
  final Function? onPressed;
  final IconData? iconData;
  final Color color;

  const RIcon(
      {Key? key, this.onPressed, this.iconData, this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed!(),
      child: Icon(
        iconData,
        color: color,
        size: 23,
      ),
    );
  }
}
