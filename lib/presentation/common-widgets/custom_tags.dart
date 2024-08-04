import 'package:flutter/material.dart';
import 'package:rasooc/presentation/common-widgets/custom_text.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class RTags extends StatelessWidget {
  final String? tag;
  final Color? backgroundColor;
  final Color? tagColor;
  final EdgeInsets? margin;
  final Function()? onPressed;

  const RTags(
      {Key? key,
      this.tag,
      this.backgroundColor,
      this.tagColor,
      this.margin,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor ?? RColors.secondaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: RText(
          tag ?? "NA",
          variant: TypographyVariant.h2,
          style: TextStyle(color: tagColor ?? Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
