import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/content_campaigns_model.dart';
import 'package:rasooc/domain/models/content_rights_model.dart';
import 'package:rasooc/domain/providers/post_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class ContentCampaignDeclined extends StatefulWidget {
  @override
  _ContentCampaignDeclinedState createState() =>
      _ContentCampaignDeclinedState();
}

class _ContentCampaignDeclinedState extends State<ContentCampaignDeclined> {
  @override
  void initState() {
    super.initState();
    intitalize();
  }

  Future<void> intitalize() async {
    final state = Provider.of<PostState>(context, listen: false);
    await state.getContentCampaigns(ContentStatus.declined);
    if (state.error.isNotEmpty) {
      Utility.displaySnackbar(context,
          msg: "Some unexpected error occured. Please try again later");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: RText(
          "Declined",
          variant: TypographyVariant.titleSmall,
        ),
      ),
      body: Consumer<PostState>(
        builder: (context, state, _) => state.isLoading
            ? Center(child: RLoader())
            : state.listOfContentCampaigns.isNotEmpty
                ? SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: state.listOfContentCampaigns
                          .map((model) => _buildItem(model))
                          .toList(),
                    ),
                  )
                : Center(
                    child: RNoDataContainer(
                      headingTitle: "No Declined content campaigns",
                      subHeading:
                          "Your declined content campaigns will be here.",
                    ),
                  ),
      ),
    );
  }

  Widget _buildItem(ContentCampaignsModel model) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RText(
                  model.createdAt.toString().split(" ")[0],
                  variant: TypographyVariant.h3,
                  style: TextStyle(
                    color: RColors.disableColor,
                  ),
                ),
                Spacer(),
                RText(
                  model.bcaSpend != null ? "\$ ${model.bcaSpend!}" : "N.A",
                  variant: TypographyVariant.h2,
                  style: TextStyle(
                      // color: RColors.disableColor,
                      ),
                ),
              ],
            ).pH(20),
            const SizedBox(height: 10),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: customNetworkImage(
                    model.campaignImage ??
                        "https://cdn.pixabay.com/photo/2018/10/15/14/58/cheetah-3749168_1280.jpg",
                    height: 66,
                    width: 66,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RText(
                        "Requested By",
                        variant: TypographyVariant.h3,
                        style: TextStyle(
                          color: RColors.secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      RText(
                        model.campaignTitle ?? "Title",
                        variant: TypographyVariant.h1,
                        style: TextStyle(fontSize: 15),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ).pH(20),
            RDivider().pH(20),
            SizedBox(height: 5),
            AspectRatio(
              aspectRatio: 1.5,
              child: customNetworkImage(
                  model.influencerImage ??
                      "https://cdn.pixabay.com/photo/2020/05/17/08/33/garden-5180550_1280.jpg",
                  fit: BoxFit.cover),
            )
          ],
        ),
      ),
    );
  }
}
