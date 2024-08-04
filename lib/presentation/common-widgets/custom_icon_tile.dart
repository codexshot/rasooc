import 'package:flutter/material.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';

class RIconTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function? onPressed;

  const RIconTile({
    Key? key,
    required this.iconData,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed!();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Column(
          children: [
            Row(
              children: [
                Icon(iconData),
                SizedBox(width: 10),
                RText(
                  title,
                  variant: TypographyVariant.h2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
