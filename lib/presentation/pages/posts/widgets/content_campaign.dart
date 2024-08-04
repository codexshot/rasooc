import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rasooc/domain/models/icon_model.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/pages/content/content-campaigns/content_campaign_accepted.dart';
import 'package:rasooc/presentation/pages/content/content-campaigns/content_campaign_declined.dart';
import 'package:rasooc/presentation/pages/content/content-campaigns/content_campaign_requested.dart';
import 'package:rasooc/presentation/pages/content/content-campaigns/content_campaign_sold.dart';

class ContentCamgainPost extends StatefulWidget {
  @override
  _ContentCamgainPostState createState() => _ContentCamgainPostState();
}

class _ContentCamgainPostState extends State<ContentCamgainPost> {
  List<IconModel> _listOfOptions = [];

  @override
  void initState() {
    super.initState();
    initializeList();
  }

  void initializeList() {
    _listOfOptions = [
      IconModel(
          title: "Pending",
          onPressed: () {
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => ContentCampaignPending()));
          }),
      IconModel(
          title: "Accepted",
          onPressed: () {
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => ContentCampaignAccepted()));
          }),
      IconModel(
          title: "Sold",
          onPressed: () {
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => ContentCampaignSold()));
          }),
      IconModel(
          title: "Declined",
          onPressed: () {
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => ContentCampaignDeclined()));
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
          "Content Campaigns",
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
