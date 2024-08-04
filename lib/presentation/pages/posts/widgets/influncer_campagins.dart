import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rasooc/domain/models/icon_model.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/pages/posts/screens/approved_post_screen.dart';
import 'package:rasooc/presentation/pages/posts/screens/declined_post_screen.dart';
import 'package:rasooc/presentation/pages/posts/screens/pending/pending_post_screen.dart';
import 'package:rasooc/presentation/pages/posts/screens/publised_post_screen.dart';
import 'package:rasooc/presentation/pages/posts/screens/withdrawn_post_screen.dart';

class InfluncerSubmissionsPost extends StatefulWidget {
  @override
  _InfluncerSubmissionsPostState createState() =>
      _InfluncerSubmissionsPostState();
}

class _InfluncerSubmissionsPostState extends State<InfluncerSubmissionsPost> {
  List<IconModel> _listOfOptions = [];

  @override
  void initState() {
    super.initState();
    initializeList();
  }

  void initializeList() {
    _listOfOptions = [
      // IconModel(title: "Upload Progress", onPressed: () {}),
      IconModel(
          title: "Pending",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => PendingPostScreen(),
            ));
          }),
      IconModel(
          title: "Approved",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => ApprovedPostScreen(),
            ));
          }),
      IconModel(
          title: "Published",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => PublishedPostScreen(),
            ));
          }),
      IconModel(
          title: "Withdrawn",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => WithdrawnPostScreen(),
            ));
          }),
      IconModel(
          title: "Declined",
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => DeclinedPostScreen(),
            ));
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
        RText("Influencer Submissions", variant: TypographyVariant.h1),
        SizedBox(height: 10),
        ..._listOfOptions
            .map((option) => _buildTile(option.title!, option.onPressed!))
            .toList(),
      ],
    );
  }
}
