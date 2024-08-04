import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/campaign_short_model.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';
import 'package:rasooc/domain/providers/submission_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/pages/campaign-details/campaign_detail_screen.dart';
import 'package:rasooc/presentation/pages/campaigns/widgets/add_to_fav_icon.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class CampaignItem extends StatefulWidget {
  final CampaignShortModel? campaignShortModel;
  final GlobalKey<ScaffoldMessengerState>? scaffoldKey;

  const CampaignItem(
      {Key? key, required this.campaignShortModel, required this.scaffoldKey})
      : super(key: key);

  @override
  _CampaignItemState createState() => _CampaignItemState();
}

class _CampaignItemState extends State<CampaignItem> {
  Color _buttonColor = RColors.primaryColor;
  bool _canUserMakeSubmission = false;

  ///`setting button color`
  void setColor() {
    switch (widget.campaignShortModel?.applied_status) {
      case CampaignStatus.apply:
        _buttonColor = RColors.primaryColor;
        break;
      case CampaignStatus.applied:
        _buttonColor = RColors.favColor;
        break;
      case CampaignStatus.shortlisted:
        _buttonColor = RColors.favColor;
        break;
      case CampaignStatus.selected:
        _buttonColor = RColors.primaryColor;
        _canUserMakeSubmission = true;
        break;
      case CampaignStatus.declined:
        _buttonColor = RColors.redColor;
        break;
      case CampaignStatus.withdraw:
        _buttonColor = RColors.favColor;
        break;
      default:
        _buttonColor = RColors.primaryColor;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    setColor();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final state = Provider.of<CampaignState>(context, listen: false);
        final id = widget.campaignShortModel?.id;
        if (id != null) {
          Provider.of<SubmissionState>(context, listen: false).setCampaignId(
              id); //Setting Campaign ID for submission to submission state

          state.getCampaignDetail(id); //Fetching details of campagin
        }

        NavigationHelpers.push(
            context,
            CampaignDetailScreen(
              hideBNB: !_canUserMakeSubmission,
            ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: customNetworkImage(
                      widget.campaignShortModel?.coverImage,
                      fit: BoxFit.cover,
                      width: sizeConfig.safeWidth! * 100,
                      defaultHolder: Image.asset(
                        RImages.islamabadImage,
                        width: sizeConfig.safeWidth! * 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 5.0,
                  child: AddToFavIcon(
                    minHeight: 35,
                    maxHeight: 50,
                    campaignId: widget.campaignShortModel?.id,
                    isFavCampaign: widget.campaignShortModel?.favourite,
                  ),
                ),
                Positioned(
                  top: 10.0,
                  left: 5.0,
                  child: GestureDetector(
                    onTap: () async {
                      await _applyStatusChange(context);
                    },
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          _buttonColor,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: null,
                      child: RText(
                        widget.campaignShortModel?.applied_status?.asString() ??
                            "Apply",
                        variant: TypographyVariant.h3,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RText(
                widget.campaignShortModel?.title?.capitalize() ??
                    "Campaign Title",
                variant: TypographyVariant.h1,
              ),
              Row(
                children: widget.campaignShortModel?.submissionType
                        ?.getLogosFromList() ??
                    [],
              )
            ],
          ),
          SizedBox(height: 5),
          RText(
            widget.campaignShortModel?.aboutBrand?.capitalize() ??
                "This will be some kind of description that will be here & we will write some thing amazing with this wow and yes therre will be so much fin ahhaha",
            variant: TypographyVariant.h2,
            style: TextStyle(
              color: RColors.secondaryColor,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _applyStatusChange(BuildContext context) async {
    //APPLYING
    final state = Provider.of<CampaignState>(context, listen: false);

    switch (widget.campaignShortModel?.applied_status) {
      case CampaignStatus.apply:
        {
          final applied =
              await state.applyToCampaign(widget.campaignShortModel?.id);

          if (applied) {
            widget.campaignShortModel?.appliedStatus = CampaignStatus.applied;
            setColor();
            state.notifyListeners();
            Utility.displaySnackbar(context,
                msg: "Applied successfully to the campaign",
                key: widget.scaffoldKey);
          } else {
            Utility.displaySnackbar(context,
                msg: "Couldn't process your request right now.Try again later",
                key: widget.scaffoldKey);
          }
        }
        break;
      case CampaignStatus.applied:
        break;
      case CampaignStatus.shortlisted:
        break;
      case CampaignStatus.selected:
        break;
      case CampaignStatus.declined:
        break;
      case CampaignStatus.withdraw:
        break;
      default:
        break;
    }
  }
}
