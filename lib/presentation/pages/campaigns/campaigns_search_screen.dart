import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/models/campaign_short_model.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_no_data_container.dart';
import 'package:rasooc/presentation/pages/campaigns/widgets/campaign_item.dart';
import 'package:rasooc/presentation/pages/campaigns/widgets/campaign_search_field.dart';
import 'package:rasooc/presentation/themes/extensions.dart';

class CampaignsSearchScreen extends StatefulWidget {
  @override
  _CampaignsSearchScreenState createState() => _CampaignsSearchScreenState();
}

class _CampaignsSearchScreenState extends State<CampaignsSearchScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30, top: 20),
          child: Column(
            children: [
              Container(
                  height:MediaQuery.of(context).size.height*.07,
                  child: FittedBox(
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios)),
                        CampaignSearchField(),
                        SizedBox(width: 20,),
                      ],
                    ),
                  )),
              Container(
                height: MediaQuery.of(context).size.height*.8,
                child: Consumer<CampaignState>(builder: (context, state, _) {
                  return state.isLoading
                      ? SizedBox(
                          height: sizeConfig.safeHeight! * 70,
                          child: Center(
                            child: RLoader(),
                          ),
                        )
                      : state.query.isNotEmpty
                          ? state.searchedCampaigns.isEmpty
                              ? SizedBox(
                                  height: sizeConfig.safeHeight! * 70,
                                  child: Center(
                                    child: RNoDataContainer(
                                      headingTitle: "No Result",
                                      subHeading:
                                          "Please enter another keyword",
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 20),
                                  child: state.searchedCampaigns.isNotEmpty
                                      ? Column(
                                          children: state.searchedCampaigns
                                              .map((model) =>
                                                  _buildCampaigns(model))
                                              .toList(),
                                        )
                                      : SizedBox(),
                                )
                          : SizedBox(
                              height: sizeConfig.safeHeight! * 70,
                              child: Center(
                                child: RNoDataContainer(
                                  headingTitle: "Search Campaigns",
                                  subHeading:
                                      "They gonna appear here, trust us.",
                                ),
                              ),
                            );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampaigns(CampaignShortModel model) {
    return CampaignItem(
      campaignShortModel: model,
      scaffoldKey: _scaffoldKey,
    );
  }
}
