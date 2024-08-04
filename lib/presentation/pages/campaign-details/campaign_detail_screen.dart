import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/models/campaign_detail_model.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/pages/campaign-details/widgets/campagin_bnb.dart';
import 'package:rasooc/presentation/pages/campaign-details/widgets/campagin_detail_body.dart';
import 'package:rasooc/presentation/pages/campaign-details/widgets/campaign_detail_image.dart';
import 'package:rasooc/presentation/pages/campaigns/widgets/add_to_fav_icon.dart';

class CampaignDetailScreen extends StatefulWidget {
  final bool hideBNB;

  const CampaignDetailScreen({Key? key, this.hideBNB = false})
      : super(key: key);
  @override
  _CampaignDetailScreenState createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  bool lastStatus = true;

  late ScrollController _scrollController;

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (230 - kToolbarHeight);
  }

  List<Widget> _buildActionsItem(CampaignDetailModel campaign) {
    return [
      GestureDetector(
        onTap: () {},
        child: Icon(
          Icons.share,
          color: isShrink ? Colors.black : Colors.white,
          size: 23,
        ),
      ),
      SizedBox(width: 20),
      AddToFavIcon(
        minHeight: 30,
        maxHeight: 50,
        campaignId: campaign.id,
        isFavCampaign: campaign.favourite,
        color: isShrink ? Colors.black : Colors.white,
      ),
      SizedBox(width: 20),
    ];
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Consumer<CampaignState>(
      builder: (context, state, child) {
        final campaign = state.selectedCampaign;

        return state.isLoading
            ? Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: RLoader()),
              )
            : campaign.id != null && campaign.id != 0
                ? Scaffold(
                    backgroundColor: Colors.white,
                    bottomNavigationBar: widget.hideBNB
                        ? SizedBox()
                        : CampaignBNB(
                            campaignDetailModel: campaign,
                          ),
                    body: SafeArea(
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          SliverAppBar(
                            elevation: 2.0,
                            backgroundColor: Colors.white,
                            title: isShrink
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: customNetworkImage(
                                      campaign.brandLogo ??
                                          "https://cdn.pixabay.com/photo/2021/02/08/16/03/dinosaur-5995333_1280.png",
                                      height: sizeConfig.safeHeight! * 5,
                                      width: sizeConfig.safeWidth! * 10,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(),
                            leading: GestureDetector(
                              onTap: () {
                                state.clearSelectedCampaign();
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: isShrink ? Colors.black : Colors.white,
                                size: 23,
                              ),
                            ),
                            actions: _buildActionsItem(campaign),
                            centerTitle: true,
                            pinned: true,
                            flexibleSpace: isShrink
                                ? Container()
                                : CampaignDetailImage(
                                    brandLogo: campaign.brandLogo,
                                    coverImage: campaign.coverImage,
                                  ),
                            expandedHeight: sizeConfig.safeHeight! * 33,
                          ),
                          SliverToBoxAdapter(
                            child: CampaignDetailBody(
                              campaign: campaign,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Scaffold(
                    appBar: AppBar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      elevation: 0.0,
                      leading: GestureDetector(
                        onTap: () {
                          state.clearSelectedCampaign();
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    body: Center(
                      child: RNoDataContainer(
                        headingTitle: "Oops! No releated Campaign found",
                        subHeading:
                            "Sorry but we can find this campaign,contact support for more information",
                      ),
                    ),
                  );
      },
    );
  }
}
