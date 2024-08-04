import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class RNoDataContainer extends StatelessWidget {
  final String? headingTitle;
  final String? subHeading;

  const RNoDataContainer({
    Key? key,
    this.headingTitle,
    this.subHeading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return SizedBox(
      width: sizeConfig.safeWidth! * 100,
      // height: sizeConfig.safeHeight! * 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            RImages.dashboardNoCampaignImage,
          ),
          SizedBox(height: 30),
          RText(
            headingTitle ?? "Campaign for this category",
            variant: TypographyVariant.titleSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          SizedBox(
            width: sizeConfig.safeWidth! * 50,
            child: RText(
              subHeading ?? "Currently there are none active",
              variant: TypographyVariant.h1,
              style: TextStyle(
                color: RColors.secondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
