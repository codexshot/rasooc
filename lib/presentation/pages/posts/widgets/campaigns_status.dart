import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/models/icon_model.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/pages/content/content-campaigns/content_campaign_accepted.dart';
import 'package:rasooc/presentation/pages/content/content-campaigns/content_campaign_declined.dart';
import 'package:rasooc/presentation/pages/content/content-campaigns/content_campaign_requested.dart';
import 'package:rasooc/presentation/pages/content/content-campaigns/content_campaign_sold.dart';
import 'package:rasooc/presentation/pages/posts/screens/campagin-status/influencer_campaign_status_screen.dart';

class CampaignsStatus extends StatefulWidget {
  @override
  _CampaignsStatusState createState() => _CampaignsStatusState();
}

class _CampaignsStatusState extends State<CampaignsStatus> {
  List<IconModel> _listOfOptions = [];

  @override
  void initState() {
    super.initState();
    initializeList();
  }

  void initializeList() {
    _listOfOptions = [
      IconModel(
          title: "Applied",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (_) => InfluencerCampaginStatusScreen(
                      status: CampaignStatus.applied,
                    )));
          }),
      IconModel(
          title: "Shortlisted",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (_) => InfluencerCampaginStatusScreen(
                      status: CampaignStatus.shortlisted,
                    )));
          }),
      IconModel(
          title: "Selected",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (_) => InfluencerCampaginStatusScreen(
                      status: CampaignStatus.selected,
                    )));
          }),
      IconModel(
          title: "Widthdrawn",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (_) => InfluencerCampaginStatusScreen(
                      status: CampaignStatus.withdraw,
                    )));
          }),
      IconModel(
          title: "Declined",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
                builder: (_) => InfluencerCampaginStatusScreen(
                      status: CampaignStatus.declined,
                    )));
          }),
    ];
  }

  Widget _buildTile(String title, Function onPressed) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(vertical: 5),
        child: RText(
          title,
          variant: TypographyVariant.h2,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RText(
          "Influencer Campaigns Status",
          variant: TypographyVariant.h1,
        ),
        SizedBox(height: 10),
        ..._listOfOptions
            .map((option) => _buildTile(option.title!, option.onPressed!))
            .toList(),
      ],
    );
  }
}
