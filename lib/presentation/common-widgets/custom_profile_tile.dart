import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class RProfileTile extends StatelessWidget {
  final String? profilePic;
  final CampaignSocialType? accountType;
  final String? userName;
  final int? followersCount;

  const RProfileTile(
      {Key? key,
      this.profilePic,
      this.accountType,
      this.userName,
      this.followersCount})
      : super(key: key);

  String getTypeImage() {
    switch (accountType) {
      case CampaignSocialType.instagram:
        return RImages.instaCamp;

      case CampaignSocialType.facebook:
        return RImages.facebookCamp;

      case CampaignSocialType.twitter:
        return RImages.twitterCamp;

      default:
        return RImages.instaCamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: customNetworkImage(
                  profilePic,
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50,
                ),
              ),
              Positioned(
                right: -2.0,
                bottom: -2.0,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    getTypeImage(),
                    height: 12,
                    width: 12,
                    color: RColors.secondaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RText(
                userName ?? "User name",
                variant: TypographyVariant.h2,
              ),
              SizedBox(height: 5),
              RText(
                followersCount != null
                    ? "${(followersCount!.getFollowers())!} followers"
                    : "0 followers",
                variant: TypographyVariant.h3,
                style: TextStyle(color: RColors.disableColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
