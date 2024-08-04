import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/post_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/pages/posts/screens/campagin-status/widgets/influencer_campaign_status_tile.dart';
import 'package:rasooc/presentation/pages/posts/widgets/post_app_bar.dart';
import 'package:rasooc/domain/helper/enums.dart';

class InfluencerCampaginStatusScreen extends StatefulWidget {
  final CampaignStatus? status;
  const InfluencerCampaginStatusScreen({Key? key, this.status})
      : super(key: key);

  @override
  _InfluencerCampaginStatusScreenState createState() =>
      _InfluencerCampaginStatusScreenState();
}

class _InfluencerCampaginStatusScreenState
    extends State<InfluencerCampaginStatusScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  bool hasMoreOptions = false;

  Future<void> withdrawCampaign(int campaignId) async {
    final state = Provider.of<PostState>(context, listen: false);
    final status = widget.status;
    if (status != null || status?.asStatus() != 1) {
      _isLoading.value = true;
      final isWithrawn = await state.withdrawInfluencerCampaign(campaignId);
      _isLoading.value = false;
      if (state.error.isNotEmpty || !isWithrawn) {
        Utility.displaySnackbar(context,
            msg: "Some error occured.Please try again later");
      }
      await getInfluencerCampaignList();
    } else {
      Utility.displaySnackbar(context,
          msg: "We can't perform this operation right now");
    }
  }

  @override
  void initState() {
    super.initState();
    getInfluencerCampaignList();
  }

  void getIfMoreOptions(CampaignStatus status) {
    switch (status) {
      case CampaignStatus.apply:
        hasMoreOptions = true;
        break;
      case CampaignStatus.applied:
        hasMoreOptions = true;
        break;
      case CampaignStatus.shortlisted:
        hasMoreOptions = true;
        break;
      case CampaignStatus.selected:
        hasMoreOptions = false;
        break;
      case CampaignStatus.declined:
        hasMoreOptions = false;
        break;
      case CampaignStatus.withdraw:
        hasMoreOptions = false;
        break;
    }
  }

  Future<void> getInfluencerCampaignList() async {
    final state = Provider.of<PostState>(context, listen: false);
    final status = widget.status;
    if (status != null || status?.asStatus() != 1) {
      _isLoading.value = true;
      await state.getInfluencerCampaignStatus(status!, pageId: 1);
      getIfMoreOptions(status);
      _isLoading.value = false;
      if (state.error.isNotEmpty) {
        Utility.displaySnackbar(context,
            msg: "Some error occured.Please try again later");
      }
    } else {
      Utility.displaySnackbar(context,
          msg: "We can't perform this operation right now");
    }
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PostAppBar(
        title: (widget.status!.asString())!,
        onLeadingPress: () {
          Navigator.of(context).pop();
        },
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _isLoading,
        builder: (context, isLoading, _) => isLoading
            ? Center(child: RLoader())
            : Consumer<PostState>(
                builder: (context, state, _) =>
                    state.listOfInfluencerCampaignsStatus.isNotEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              children: state.listOfInfluencerCampaignsStatus
                                  .map(
                                    (model) => InfluencerCampaignStatusTile(
                                      campaignShortModel: model,
                                      haveOptions: hasMoreOptions,
                                      onPressed: () async {
                                        withdrawCampaign(model.id!);
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          )
                        : Center(
                            child: RNoDataContainer(
                              headingTitle:
                                  "No ${widget.status?.asString()} campaigns",
                              subHeading:
                                  "Your ${widget.status?.asString()?.toLowerCase()} campaigns will be available here",
                            ),
                          ),
              ),
      ),
    );
  }
}
