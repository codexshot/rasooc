import 'package:flutter/material.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/themes/colors.dart';

class RFlatButton extends StatelessWidget {
  final Function? onPressed;
  final String title;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final ValueNotifier<bool>? isLoading;

  const RFlatButton({
    Key? key,
    this.onPressed,
    required this.title,
    this.color,
    this.padding,
    this.textColor,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: SizedBox(
        height: 48,
        width: 320,
        child: FlatButton(
          color: color ?? RColors.primaryColor,
          textColor: Colors.white,
          minWidth: double.maxFinite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          onPressed: onPressed!(),
          child: RText(
            title,
            variant: TypographyVariant.h3,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );

    // Container(
    //   height: 48,
    //   width: 320,
    //   child: TextButton(
    //     style: ButtonStyle(
    //       backgroundColor: MaterialStateProperty.all<Color>(
    //           color ?? const Color(0xff27DEBF)),
    //       textStyle: MaterialStateProperty.all<TextStyle>(
    //         TextStyle(
    //           color: textColor ?? Colors.white,
    //         ),
    //       ),
    //     ),
    //     // minWidth: double.maxFinite,
    //     // shape:
    //     //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
    //     child: Text(title!),
    //     onPressed: () {
    //       onPressed!();
    //     },
    //   ),
    // ),
  }
}
