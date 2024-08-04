import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rasooc/domain/models/icon_model.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/pages/content/content-rights/content_right_accepted.dart';
import 'package:rasooc/presentation/pages/content/content-rights/content_right_requested.dart';
import 'package:rasooc/presentation/pages/content/content-rights/content_rights_sold.dart';
import 'package:rasooc/presentation/pages/content/content-rights/content_rights_declined.dart';

class ContentRightsPost extends StatefulWidget {
  @override
  _ContentRightsPostState createState() => _ContentRightsPostState();
}

class _ContentRightsPostState extends State<ContentRightsPost> {
  List<IconModel> _listOfOptions = [];

  @override
  void initState() {
    super.initState();
    initializeList();
  }

  void initializeList() {
    _listOfOptions = [
      IconModel(
          title: "Requested",
          onPressed: () {
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => ContentRightRequested()));
          }),
      IconModel(
          title: "Accepted",
          onPressed: () {
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => ContentRightAccepted()));
          }),
      IconModel(
          title: "Sold",
          onPressed: () {
            Navigator.of(context)
                .push(CupertinoPageRoute(builder: (_) => ContentRightSold()));
          }),
      IconModel(
          title: "Declined",
          onPressed: () {
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => ContentRightDeclined()));
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
        RText("Content Rights", variant: TypographyVariant.h1),
        SizedBox(height: 10),
        ..._listOfOptions
            .map((option) => _buildTile(option.title!, option.onPressed!))
            .toList(),
      ],
    );
  }
}
