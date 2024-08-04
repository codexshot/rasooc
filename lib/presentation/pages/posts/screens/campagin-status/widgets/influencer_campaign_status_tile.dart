import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/models/campaign_short_model.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/pages/campaign-details/campaign_detail_screen.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

///`Generic view tile for every screen under POSTS`
///`This is not tappable & non-editable field`
class InfluencerCampaignStatusTile extends StatefulWidget {
  final CampaignShortModel campaignShortModel;
  final bool haveOptions;
  final Function()? onPressed;

  const InfluencerCampaignStatusTile(
      {Key? key,
      required this.campaignShortModel,
      this.haveOptions = false,
      this.onPressed})
      : super(key: key);
  @override
  _InfluencerCampaignStatusTileState createState() =>
      _InfluencerCampaignStatusTileState();
}

class _InfluencerCampaignStatusTileState
    extends State<InfluencerCampaignStatusTile> {
  late CampaignShortModel model;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    model = widget.campaignShortModel;
  }

  Future<void> showModalSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: RText(
                        "Are you sure you want to withdraw your submission?",
                        variant: TypographyVariant.h1),
                    actions: [
                      TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              RColors.primaryColor,
                            )),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await widget.onPressed!();
                          setState(() {
                            isLoading = true;
                          });
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: isLoading
                            ? Center(
                                child: RLoader(),
                              )
                            : RText(
                                "Sure",
                                variant: TypographyVariant.h1,
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      SizedBox(width: 20),
                      TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              RColors.redColor,
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: isLoading
                            ? Center(
                                child: RLoader(),
                              )
                            : RText(
                                "Cancel",
                                variant: TypographyVariant.h1,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      )
                    ],
                  ),
                );
              },
              child: Column(
                children: [
                  SizedBox(height: 10),
                  RText("Withdraw Submission", variant: TypographyVariant.h1),
                  SizedBox(height: 10),
                ],
              ),
            ),
            RDivider(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  SizedBox(height: 10),
                  RText(
                    "Cancel",
                    variant: TypographyVariant.h1,
                    style: TextStyle(color: RColors.redColor),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///`Short desc of the Pending submission`
  Widget _buildShortTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.haveOptions)
            GestureDetector(
              onTap: () async {
                await showModalSheet();
              },
              child: Icon(
                Icons.more_horiz,
                color: RColors.primaryColor,
              ),
            )
          else
            SizedBox(),
          SizedBox(
            height: 65,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: customNetworkImage(
                    model.coverImage ??
                        "https://cdn.pixabay.com/photo/2020/09/16/11/48/donkeys-5576167_1280.jpg",
                    height: 52,
                    width: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RText(
                        "Submitted to",
                        variant: TypographyVariant.h3,
                        style: TextStyle(
                            fontSize: 12, color: RColors.secondaryColor),
                      ),
                      RText(
                        model.title ?? "Brand Name",
                        variant: TypographyVariant.h1,
                        style: TextStyle(fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Spacer(),
                ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(horizontal: 20)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          RColors.primaryColor),
                    ),
                    onPressed: () {
                      if (model.id != null && model.id != 0) {
                        Provider.of<CampaignState>(context, listen: false)
                            .getCampaignDetail(model.id!);
                        NavigationHelpers.push(
                          context,
                          CampaignDetailScreen(
                            hideBNB: true,
                          ),
                        );
                      }
                    },
                    child: RText(
                      "View",
                      variant: TypographyVariant.h3,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: RColors.addImageColor,
        // color: Colors.red,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShortTile(),
        ],
      ),
    ).pH(20);
  }
}
