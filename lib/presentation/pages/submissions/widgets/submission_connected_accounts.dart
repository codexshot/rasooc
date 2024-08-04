import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/models/social_accounts_model.dart';
import 'package:rasooc/domain/providers/social_account_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/pages/profile-settings/screens/select_platform.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class SubmissionConnectedAccounts extends StatefulWidget {
  const SubmissionConnectedAccounts(
      {Key? key, this.socialType, this.submissionType})
      : super(key: key);

  final List<CampaignSocialType>? socialType;
  final CampaignSubmissionType? submissionType;

  @override
  _SubmissionConnectedAccountsState createState() =>
      _SubmissionConnectedAccountsState();
}

class _SubmissionConnectedAccountsState
    extends State<SubmissionConnectedAccounts> {
  Widget _buildInstaAccount(InstaAccount instaAccount,
      {bool fromShowSelected = false}) {
    return GestureDetector(
      onTap: fromShowSelected
          ? () {
              showAccountModalSheet();
            }
          : () {
              final accountState =
                  Provider.of<SocialAccountState>(context, listen: false);
              accountState.setInstaAccount(instaAccount);
              Navigator.of(context).pop();
            },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: customNetworkImage(
                    instaAccount.profilePictureUrl,
                    fit: BoxFit.cover,
                    height: 45,
                    width: 45,
                  ),
                ),
                Positioned(
                  right: -2.0,
                  bottom: -2.0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      RImages.instaCamp,
                      height: 12,
                      width: 12,
                      color: RColors.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RText(
                  instaAccount.username ?? "User name",
                  variant: TypographyVariant.h2,
                ),
                SizedBox(height: 5),
                RText(
                  instaAccount.followersCount != null
                      ? "${(instaAccount.followersCount!.getFollowers())!} Followers"
                      : "0 followers",
                  variant: TypographyVariant.h3,
                  style: TextStyle(color: RColors.disableColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFacebookAccounts(FacebookPageAccount fbPageAccount,
      {bool fromShowSelected = false}) {
    //Require a model
    return GestureDetector(
      onTap: fromShowSelected
          ? () {
              showAccountModalSheet();
            }
          : () {
              final accountState =
                  Provider.of<SocialAccountState>(context, listen: false);
              accountState.setFacebookAccount(fbPageAccount);
              Navigator.of(context).pop();
            },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: customNetworkImage(
                    fbPageAccount.profilePictureUrl,
                    fit: BoxFit.cover,
                    height: 45,
                    width: 45,
                    defaultHolder: SvgPicture.asset(
                      RImages.facebookLogo,
                      height: 45,
                      width: 45,
                    ),
                  ),
                ),
                Positioned(
                  right: -2.0,
                  bottom: -2.0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      RImages.facebookCamp,
                      height: 12,
                      width: 12,
                      color: RColors.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RText(
                  fbPageAccount.name ?? "User name",
                  variant: TypographyVariant.h2,
                ),
                SizedBox(height: 5),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTwitterAccounts(TwitterAccount twitterAccount,
      {bool fromShowSelected = false}) {
    //Require a model
    return GestureDetector(
      onTap: fromShowSelected
          ? () {
              showAccountModalSheet();
            }
          : () {
              final accountState =
                  Provider.of<SocialAccountState>(context, listen: false);
              accountState.setTwitterAccount(twitterAccount);
              Navigator.of(context).pop();
            },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: customNetworkImage(
                    twitterAccount.profilePictureUrl,
                    // fit: BoxFit.cover,
                    height: 45,
                    width: 45,
                    defaultHolder: SvgPicture.asset(
                      RImages.twitterLogo,
                      height: 35,
                      width: 35,
                    ),
                  ),
                ),
                Positioned(
                  right: -2.0,
                  bottom: -2.0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.white,
                    child: SvgPicture.asset(
                      RImages.twitterCamp,
                      height: 12,
                      width: 12,
                      color: RColors.secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RText(
                  twitterAccount.userName ?? "User name",
                  variant: TypographyVariant.h2,
                ),
                SizedBox(height: 5),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showAccountModalSheet() {
    final socialType = widget.socialType ?? [];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RText("Choose an account", variant: TypographyVariant.h1),
              SizedBox(height: 20),
              Consumer<SocialAccountState>(builder: (context, state, _) {
                final instaAccount = state.socialAccountsModel.instaDetails;
                final facebookAccounts =
                    state.socialAccountsModel.facebookDetails;
                final twitterAccounts =
                    state.socialAccountsModel.twitterDetails;

                final List<Widget> listOfWidgets = [];

                if (socialType.contains(CampaignSocialType.instagram) &&
                    instaAccount != null) {
                  listOfWidgets.add(_buildInstaAccount(instaAccount));
                }
                if (socialType.contains(CampaignSocialType.facebook) &&
                    facebookAccounts != null &&
                    facebookAccounts.isNotEmpty) {
                  for (final fbPage in facebookAccounts) {
                    listOfWidgets.add(_buildFacebookAccounts(fbPage));
                  }
                }
                if (socialType.contains(CampaignSocialType.twitter) &&
                    twitterAccounts != null &&
                    twitterAccounts.isNotEmpty) {
                  for (final account in twitterAccounts) {
                    listOfWidgets.add(_buildTwitterAccounts(account));
                  }
                }

                ///`----------------------------------`
                if (listOfWidgets.isNotEmpty) {
                  return Column(
                    children: listOfWidgets,
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    child: Center(
                        child: state.isLoading
                            ? RLoader()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RText(
                                    "No account linked",
                                    variant: TypographyVariant.h1,
                                  ),
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                        CupertinoPageRoute(
                                            builder: (_) =>
                                                ProfileSelectPlatform())),
                                    child: RText(
                                      "Link account",
                                      variant: TypographyVariant.h3,
                                      style: TextStyle(
                                          color: RColors.primaryColor),
                                    ),
                                  ),
                                ],
                              )),
                  );
                }
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _showConnectedAccount() {
    return Consumer<SocialAccountState>(
      builder: (context, state, _) => GestureDetector(
        onTap: () {
          if (state.socialAccountsModel.instaDetails != null ||
              (state.socialAccountsModel.facebookDetails != null &&
                  state.socialAccountsModel.facebookDetails!.isNotEmpty) ||
              state.socialAccountsModel.twitterDetails != null &&
                  state.socialAccountsModel.twitterDetails!.isNotEmpty) {
            showAccountModalSheet();
          } else {
            Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => ProfileSelectPlatform()));
          }
        },
        child: Row(
          children: [
            Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Icon(
                Icons.add,
                color: RColors.secondaryColor,
                size: 20,
              ),
            ),
            SizedBox(width: 10),
            RText(
              "Connect account",
              variant: TypographyVariant.h2,
              style: TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget _showSelectedAccount() {
    return Consumer<SocialAccountState>(
      builder: (context, state, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (state.selectedInstaAccount.instagramId != null)
            _buildInstaAccount(state.selectedInstaAccount,
                fromShowSelected: true)
          else if (state.selectedFBAccount.pageId != null)
            _buildFacebookAccounts(state.selectedFBAccount,
                fromShowSelected: true)
          else if (state.selectedTwitterAccount.userId != null)
            _buildTwitterAccounts(state.selectedTwitterAccount,
                fromShowSelected: true),
          GestureDetector(
            onTap: () {
              showAccountModalSheet();
            },
            child: Icon(
              Icons.keyboard_arrow_down,
              color: RColors.secondaryColor,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SocialAccountState>(
      builder: (context, state, _) {
        if (state.selectedInstaAccount.instagramId != null ||
            state.selectedFBAccount.pageId != null ||
            state.selectedTwitterAccount.userId != null) {
          return _showSelectedAccount();
        } else {
          return _showConnectedAccount();
        }
      },
    );
  }
}
