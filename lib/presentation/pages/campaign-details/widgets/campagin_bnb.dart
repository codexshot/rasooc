import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/models/campaign_detail_model.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/pages/submissions/create_post_submission.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/images.dart';

class CampaignBNB extends StatefulWidget {
  final CampaignDetailModel campaignDetailModel;

  const CampaignBNB({Key? key, required this.campaignDetailModel})
      : super(key: key);
  @override
  _CampaignBNBState createState() => _CampaignBNBState();
}

class _CampaignBNBState extends State<CampaignBNB> {
  final List<Widget> _childrens = [
    RText(
      "CHOOSE A SUBMISSION TYPE",
      variant: TypographyVariant.h1,
      style: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.0),
    ),
    SizedBox(height: 10),
  ];

  @override
  void initState() {
    super.initState();
    setUpTypeOfPosts();
  }

  void setUpTypeOfPosts() {
    final campaign = widget.campaignDetailModel;

    if (campaign.instaSubmissions != null &&
        campaign.instaSubmissions!.isNotEmpty) {
      for (final element in campaign.instaSubmissions!) {
        final type = element.toLowerCase();
        print("ELEMENT - $element");

        switch (type) {
          case "posts":
            final List<String> logos = [RImages.instaCamp];
            final List<CampaignSocialType> types = [
              CampaignSocialType.instagram
            ];

            if ((campaign.fbTag != null && campaign.fbTag!.isNotEmpty) &&
                (campaign.twitterTag != null &&
                    campaign.twitterTag!.isNotEmpty)) {
              logos.add(RImages.facebookCamp);
              logos.add(RImages.twitterCamp);
              types.add(CampaignSocialType.facebook);
              types.add(CampaignSocialType.twitter);
            } else {
              if (campaign.fbTag != null && campaign.fbTag!.isNotEmpty) {
                logos.add(RImages.facebookCamp);
                types.add(CampaignSocialType.facebook);
              }
              if (campaign.twitterTag != null &&
                  campaign.twitterTag!.isNotEmpty) {
                logos.add(RImages.twitterCamp);
                types.add(CampaignSocialType.twitter);
              }
            }
            _childrens.add(RDivider());
            _childrens.add(
              _buildSubmissionItem(
                Icons.add_comment_outlined,
                "Post",
                "Single media type",
                logos,
                () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => CreatePostSubmission(
                        socialType: types,
                        submissionType: CampaignSubmissionType.posts,
                      ),
                    ),
                  );
                },
              ),
            );
            break;
          case "carousel":
            _childrens.add(RDivider());
            _childrens.add(
              _buildSubmissionItem(
                Icons.add_a_photo,
                "Carousel",
                "Between 2 & 10 media files",
                [RImages.instaCamp],
                () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => CreatePostSubmission(
                        submissionType: CampaignSubmissionType.carousel,
                        socialType: const [CampaignSocialType.instagram],
                      ),
                    ),
                  );
                },
              ),
            );
            break;
          case "stories":
            _childrens.add(RDivider());
            _childrens.add(
              _buildSubmissionItem(
                Icons.add_circle_outline,
                "Story",
                "Upto 10 frames,15 sec max each",
                [RImages.instaCamp],
                () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => CreatePostSubmission(
                        submissionType: CampaignSubmissionType.stories,
                        socialType: const [CampaignSocialType.instagram],
                      ),
                    ),
                  );
                },
              ),
            );
            break;
          default:
            break;
        }
      }
    } else if (campaign.twitterTag != null && campaign.twitterTag!.isNotEmpty) {
      print("HEREEEEEEEE MODO");
      final List<String> logos = [RImages.twitterCamp];
      final List<CampaignSocialType> types = [CampaignSocialType.twitter];

      if ((campaign.fbTag != null && campaign.fbTag!.isNotEmpty) &&
          (campaign.instaTags != null && campaign.instaTags!.isNotEmpty)) {
        logos.add(RImages.instaCamp);
        logos.add(RImages.facebookCamp);
        types.add(CampaignSocialType.instagram);
        types.add(CampaignSocialType.facebook);
      } else {
        if (campaign.fbTag != null && campaign.fbTag!.isNotEmpty) {
          logos.add(RImages.facebookCamp);
          types.add(CampaignSocialType.facebook);
        }
        if (campaign.instaTags != null && campaign.instaTags!.isNotEmpty) {
          logos.add(RImages.instaCamp);
          types.add(CampaignSocialType.instagram);
        }
      }
      _childrens.add(RDivider());
      _childrens.add(
        _buildSubmissionItem(
          Icons.add_comment_outlined,
          "Post",
          "Single media type",
          logos,
          () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => CreatePostSubmission(
                  socialType: types,
                  submissionType: CampaignSubmissionType.posts,
                ),
              ),
            );
          },
        ),
      );
    } else if (campaign.fbTag != null && campaign.fbTag!.isNotEmpty) {
      final List<String> logos = [RImages.facebookCamp];
      final List<CampaignSocialType> types = [CampaignSocialType.facebook];

      if ((campaign.twitterTag != null && campaign.twitterTag!.isNotEmpty) &&
          (campaign.instaTags != null && campaign.instaTags!.isNotEmpty)) {
        logos.add(RImages.instaCamp);
        logos.add(RImages.twitterCamp);
        types.add(CampaignSocialType.instagram);
        types.add(CampaignSocialType.twitter);
      } else {
        if (campaign.twitterTag != null && campaign.twitterTag!.isNotEmpty) {
          logos.add(RImages.twitterCamp);
          types.add(CampaignSocialType.twitter);
        }
        if (campaign.instaTags != null && campaign.instaTags!.isNotEmpty) {
          logos.add(RImages.instaCamp);
          types.add(CampaignSocialType.instagram);
        }
      }
      _childrens.add(RDivider());
      _childrens.add(
        _buildSubmissionItem(
          Icons.add_comment_outlined,
          "Post",
          "Single media type",
          logos,
          () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => CreatePostSubmission(
                  socialType: types,
                  submissionType: CampaignSubmissionType.posts,
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _buildSubmissionItem(IconData icon, String type, String desc,
      List<String> logos, Function()? onTap,
      {bool isDisabled = false}) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: RColors.secondaryColor,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RText(
                      type,
                      variant: TypographyVariant.h3,
                      style: TextStyle(
                        color: RColors.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RText(
                      desc,
                      variant: TypographyVariant.h3,
                      style: TextStyle(
                        color: RColors.disableColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: logos
                  .map(
                    (logo) => Container(
                      height: 16,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: SvgPicture.asset(
                        logo,
                        color: RColors.secondaryColor,
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _childrens,
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 60,
        color: RColors.primaryColor,
        alignment: Alignment.center,
        child: RText(
          "CREATE SUBMISSION",
          variant: TypographyVariant.h1,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
