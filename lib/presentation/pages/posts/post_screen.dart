import 'package:flutter/material.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/pages/posts/widgets/campaigns_status.dart';
import 'package:rasooc/presentation/pages/posts/widgets/content_campaign.dart';
import 'package:rasooc/presentation/pages/posts/widgets/content_rights.dart';
import 'package:rasooc/presentation/pages/posts/widgets/influncer_campagins.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: RText("Post", variant: TypographyVariant.titleSmall),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CampaignsStatus().pH(20),
            RDivider(),
            InfluncerSubmissionsPost().pH(20),
            RDivider(),
            SizedBox(height: 10),
            ContentCamgainPost().pH(20),
            RDivider(),
            SizedBox(height: 10),
            ContentRightsPost().pH(20),
          ],
        ),
      ),
    );
  }
}
