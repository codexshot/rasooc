import 'package:flutter/material.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/styles.dart';

class ChargesInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => Navigator.of(context).pop(),
          color: RColors.secondaryColor,
          iconSize: 30,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopItem(),
              SizedBox(height: 10),
              RDivider(),
              SizedBox(height: 10),
              _buildInFeedPosts(),
              SizedBox(height: 10),
              RDivider(),
              SizedBox(height: 10),
              _buildBottomDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RText("How much should i charge?", variant: TypographyVariant.h1),
        SizedBox(height: 10),
        RText(
          "Currency used for this campaign: PKR",
          variant: TypographyVariant.h3,
          style: TextStyle(
            color: RColors.secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInFeedPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RText(
          "IN-FEED POSTS",
          variant: TypographyVariant.h2,
          style: TextStyle(
            color: RColors.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20),
        _buildInFeedItem("Followers", "Ballpark rate",
            style: RStyles.inFeedTextStyle.copyWith(fontSize: 13)),
        _buildInFeedItem("Per account", "Per in-feed post",
            style: RStyles.inFeedTextStyle.copyWith(fontSize: 13)),
        _buildInFeedItem("3k-25k", "\$100-\$250"),
        _buildInFeedItem("25k-50k", "\$250-\$400"),
        _buildInFeedItem("50k-100k", "\$400-\$600"),
        _buildInFeedItem("100k-500k", "\$600-\$1200"),
        _buildInFeedItem("500k-5m+", "\$1200-\$5000"),
      ],
    );
  }

  Widget _buildInFeedItem(String firstText, String secondText,
      {TextStyle style = RStyles.inFeedTextStyle}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RText(
              firstText,
              variant: TypographyVariant.h1,
              style: style,
            ),
            RText(
              secondText,
              variant: TypographyVariant.h1,
              style: style,
            ),
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _buildBottomDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RText(
          "Stories",
          variant: TypographyVariant.h2,
          style: TextStyle(
            color: RColors.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        RText(
          "50% of in-feed posts",
          variant: TypographyVariant.h2,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        RDivider(),
        SizedBox(height: 10),
        RText(
          "Carousels",
          variant: TypographyVariant.h2,
          style: TextStyle(
            color: RColors.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        RText(
          "20% more than in-feed posts",
          variant: TypographyVariant.h2,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
