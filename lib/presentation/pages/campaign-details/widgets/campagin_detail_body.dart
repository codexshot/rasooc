import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/models/campaign_detail_model.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/pages/campaign-details/widgets/additional_tags.dart';
import 'package:rasooc/presentation/pages/campaign-details/widgets/moodboard.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';
import 'package:rasooc/presentation/themes/extensions.dart';
import 'package:share/share.dart';
import 'package:social_share/social_share.dart';

class CampaignDetailBody extends StatelessWidget {
  final CampaignDetailModel campaign;

  const CampaignDetailBody({Key? key, required this.campaign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    const dummy = 'Error: Some unxpected data';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCampaignDesc().pH(20),
        RDivider().pH(20),
        _buildInfluencerRequirment().pH(20),
        RDivider().pH(20),
        _buildTitleAndContentWidget("ABOUT US", campaign.aboutBrand ?? dummy)
            .pH(20),
        RDivider().pH(20),
        _buildMoodboard(),
        RDivider().pH(20),
        _buildTitleAndContentWidget("CONTENT WE'D LOVE FROM YOU",
                campaign.moodboardContent ?? dummy)
            .pH(20),
        RDivider().pH(20),
        _buildSubmissionOptions().pH(20),
        RDivider().pH(20),
        _buildpartnerTags().pH(20),
        RDivider().pH(20),
        _buildAdditionalTags().pH(20),
        RDivider().pH(20),
        _buildDos().pH(20),
        RDivider().pH(20),
        _buildDonts().pH(20),
        RDivider().pH(20),
        _buildTitleAndContentWidget(
                "WHERE TO GET OUR PRODUCT",
                campaign.storeType?.capitalize() ??
                    "Somewhere the world stop breathing, the place where you &i will meet the place would be magical")
            .pH(20),
        RDivider().pH(20),
        // _buildTitleAndContentWidget(
        //         "CAMPAIGN CURRENCY", "Please set your fee in PKR")
        //     .pH(20),
        // RDivider().pH(20),
        _buildHouseRules().pH(20),
        RDivider().pH(20),
      ],
    );
  }

  Widget _buildCampaignDesc() {
    return Container(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          RText(
            campaign.brandName?.capitalize() ?? "Brand Title",
            variant: TypographyVariant.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5),
          RText(
            campaign.title?.capitalize() ?? "Campaign Title here something",
            variant: TypographyVariant.h1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Container(
            width: sizeConfig.safeWidth! * 70,
            child: RText(
              campaign.callToAction?.capitalize() ??
                  "Submit post like this or that here there",
              variant: TypographyVariant.h3,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RColors.secondaryColor,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfluencerRequirment() {
    final genders = campaign.influencerRequirement?.creatorsGender;
    final age = campaign.influencerRequirement?.creatorsAge;

    final creatorsAge = StringBuffer();
    for (final text in age!) {
      creatorsAge.write("$text ");
    }
    final submissions = campaign.influencerRequirement?.submissionType;
    final followers = campaign.influencerRequirement?.creatorsFollowers;
    String follow = "0 followers";

    if (followers != null) {
      final f1 = int.tryParse(followers.split(" ")[0])?.getFollowers();
      final f2 = int.tryParse(followers.split("-")[1])?.getFollowers();
      follow = "$f1 - $f2 followers";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        RText("INFLUENCER REQUIRMENTS", variant: TypographyVariant.h1),
        if (genders != null && genders.isNotEmpty)
          Row(
            children: genders
                .map(
                  (e) => RText(
                    e.toLowerCase() == "all" ? "All gender" : e.capitalize(),
                    variant: TypographyVariant.h3,
                    style: TextStyle(
                      color: RColors.secondaryColor,
                      height: 2.0,
                    ),
                  ),
                )
                .toList(),
          )
        else
          SizedBox(),
        if (creatorsAge.isNotEmpty)
          RText(
            "Age $creatorsAge",
            variant: TypographyVariant.h3,
            style: TextStyle(
              color: RColors.secondaryColor,
              height: 2.0,
            ),
          )
        else
          SizedBox(),
        if (submissions != null && submissions.isNotEmpty)
          SizedBox(
            height: 30,
            child: ListView.builder(
              itemCount: submissions.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => RText(
                index == (submissions.length - 1)
                    ? submissions[index]
                    : "${submissions[index]}, ",
                variant: TypographyVariant.h3,
                style: TextStyle(
                  color: RColors.secondaryColor,
                  height: 2.0,
                ),
              ),
            ),
          )
        else
          SizedBox(),
        if (followers != null && followers.isNotEmpty)
          RText(
            follow,
            variant: TypographyVariant.h3,
            style: TextStyle(
              color: RColors.secondaryColor,
              height: 2.0,
            ),
          )
        else
          SizedBox(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMoodboard() {
    return Moodboard(
      visualImages: campaign.visualDirection ?? [],
    );
  }

  Widget _buildSubmissionOptions() {
    final instaSubmissions = campaign.instaSubmissions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        RText("INSTAGRAM SUBMISSION OPTIONS", variant: TypographyVariant.h1),
        SizedBox(height: 10),
        if (instaSubmissions != null && instaSubmissions.isNotEmpty)
          Container(
            height: 40,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: instaSubmissions
                  .map((type) => GestureDetector(
                        onTap: () async {
                          print(type);
                          if (type == 'Stories') {
                            try {
                              // Saved with this method.
                              var imageId = await ImageDownloader.downloadImage(
                                  campaign.visualDirection![0]);
                              if (imageId == null) {
                                return;
                              }

                              // Below is a method of obtaining saved image information.
                              var fileName =
                                  await ImageDownloader.findName(imageId);
                              var path =
                                  await ImageDownloader.findPath(imageId);
                              var size =
                                  await ImageDownloader.findByteSize(imageId);
                              var mimeType =
                                  await ImageDownloader.findMimeType(imageId);
                              SocialShare.shareInstagramStory(
                                path!,
                                backgroundTopColor: "#ffffff",
                                backgroundBottomColor: "#000000",
                                attributionURL: "https://deep-link-url",
                                backgroundImagePath: path,
                              ).then((data) {
                                print(data);
                              });
                            } on PlatformException catch (error) {
                              print(error);
                            }
                          }
                          else {

                            var paths=<String>[];
                            for(int i=0;i< campaign.visualDirection!.length;i++){

                              var imageId = await ImageDownloader.downloadImage(
                                  campaign.visualDirection![i]);
                              var path =
                              await ImageDownloader.findPath(imageId!);
                              paths.add(path!);
                            }

                            Share.shareFiles(paths);
                          }

                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: RColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: RText(
                            type.capitalize(),
                            variant: TypographyVariant.h1,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        else
          SizedBox(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildpartnerTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        RText("INSTAGRAM PAID PARTNERSHIP TAG", variant: TypographyVariant.h1),
        SizedBox(height: 20),
        Container(
          height: 30,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: RColors.secondaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: RText(
            "@coffepeelo.in",
            variant: TypographyVariant.h2,
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAdditionalTags() {
    return AdditionalTags(campaign: campaign);
  }

  Widget _buildDos() {
    final dos = campaign.dos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        RText("DOs", variant: TypographyVariant.h1),
        const SizedBox(height: 10),
        if (dos != null && dos.isNotEmpty)
          Column(
            children: dos
                .map(
                  (text) => Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: RColors.greenCheckColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RText(
                            text.capitalize(),
                            variant: TypographyVariant.h3,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: RColors.secondaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          )
        else
          const SizedBox(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDonts() {
    final donts = campaign.donts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        RText("DON'Ts", variant: TypographyVariant.h1),
        SizedBox(height: 10),
        if (donts != null && donts.isNotEmpty)
          Column(
            children: donts
                .map(
                  (text) => Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cancel,
                          color: RColors.redColor,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RText(
                            text.capitalize(),
                            variant: TypographyVariant.h3,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: RColors.secondaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          )
        else
          SizedBox(),
        SizedBox(height: 20),
      ],
    );
  }

  ///`Build any plain title & content`
  Widget _buildTitleAndContentWidget(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        RText(title, variant: TypographyVariant.h1),
        RText(
          content,
          variant: TypographyVariant.h3,
          style: TextStyle(
            color: RColors.secondaryColor,
            height: 2.0,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHouseRules() {
    final houseRules = campaign.houseRules;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        RText("HOUSE RULES", variant: TypographyVariant.h1),
        SizedBox(height: 10),
        if (houseRules != null && houseRules.isNotEmpty)
          Column(
            children: houseRules
                .map(
                  (rules) => Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: RColors.secondaryColor,
                          radius: 4.0,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: RText(
                            rules,
                            variant: TypographyVariant.h2,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                )
                .toList(),
          )
        else
          SizedBox(),
        SizedBox(height: 20),
      ],
    );
  }
}
