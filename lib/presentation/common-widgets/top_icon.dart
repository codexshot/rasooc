import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rasooc/presentation/common-widgets/custom_text.dart';
import 'package:rasooc/presentation/themes/images.dart';

class TopIcon extends StatelessWidget {
  final String? imagePath;
  final String? title;

  const TopIcon({
    Key? key,
    @required this.imagePath,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SvgPicture.asset(
            imagePath ?? RImages.coronaVirusImage, //TODO: add placeholder image
            // height: 80,
          ),
          SizedBox(height: 16),
          RText(
            title ?? "Title unavailable",
            variant: TypographyVariant.title,
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
