import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/social_accounts_model.dart';
import 'package:rasooc/domain/providers/social_account_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/pages/profile-settings/screens/select_platform.dart';
import 'package:rasooc/presentation/themes/images.dart';

class ProfileSocialAccounts extends StatefulWidget {
  const ProfileSocialAccounts({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileSocialAccountsState createState() => _ProfileSocialAccountsState();
}

class _ProfileSocialAccountsState extends State<ProfileSocialAccounts> {
  bool isRemoving = false;

  Widget _buildInstaAccount(InstaAccount instaAccount) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(RImages.instaLogo),
                SizedBox(width: 10),
                RText(instaAccount.username ?? "@accountName",
                    variant: TypographyVariant.h3),
              ],
            ),
            GestureDetector(
              onTap: () async {
                setState(() => isRemoving = true);

                final socialState =
                    Provider.of<SocialAccountState>(context, listen: false);
                await socialState.removedConnectedAccount(
                    instaAccount.instagramId!,
                    isInsta: true);
                if (socialState.error.isEmpty) {
                  Utility.displaySnackbar(context,
                      msg: "Instagram account removed successfully");
                } else {
                  Utility.displaySnackbar(context,
                      msg:
                          "Some error occured while removing your Instagram account");
                }

                setState(() => isRemoving = false);
              },
              child: Icon(
                Icons.delete,
                color: Colors.black,
                size: 23,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFacebookAccounts(FacebookPageAccount fbPage) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(RImages.facebookLogo),
                SizedBox(width: 10),
                RText(fbPage.name ?? "@accountName",
                    variant: TypographyVariant.h3),
              ],
            ),
            GestureDetector(
              onTap: () async {
                setState(() => isRemoving = true);

                final socialState =
                    Provider.of<SocialAccountState>(context, listen: false);
                await socialState.removedConnectedAccount(fbPage.pageId!,
                    isFB: true);

                if (socialState.error.isEmpty) {
                  Utility.displaySnackbar(context,
                      msg: "Facebook account removed successfully");
                } else {
                  Utility.displaySnackbar(context,
                      msg:
                          "Some error occured while removing your Facebook account");
                }

                setState(() => isRemoving = false);
              },
              child: Icon(
                Icons.delete,
                color: Colors.black,
                size: 23,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTwitterAccounts(TwitterAccount twitterAccount) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(RImages.twitterLogo),
                SizedBox(width: 10),
                RText(twitterAccount.userName ?? "@accountName",
                    variant: TypographyVariant.h3),
              ],
            ),
            GestureDetector(
              onTap: () async {
                setState(() => isRemoving = true);

                final socialState =
                    Provider.of<SocialAccountState>(context, listen: false);

                await socialState.removedConnectedAccount(
                    twitterAccount.userId!,
                    isTwitter: true);

                if (socialState.error.isEmpty) {
                  Utility.displaySnackbar(context,
                      msg: "Twitter account removed successfully");
                } else {
                  Utility.displaySnackbar(context,
                      msg:
                          "Some error occured while removing your Twitter account");
                }

                setState(() => isRemoving = false);
              },
              child: Icon(
                Icons.delete,
                color: Colors.black,
                size: 23,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RText(
                  "Social Accounts",
                  variant: TypographyVariant.h1,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    CupertinoPageRoute(
                        builder: (_) => ProfileSelectPlatform(),
                        fullscreenDialog: true),
                  ),
                  child: Icon(Icons.add, color: Colors.black, size: 23),
                ),
              ],
            ),
            SizedBox(height: 20),
            Consumer<SocialAccountState>(builder: (context, state, _) {
              final instaAccount = state.socialAccountsModel.instaDetails;
              final facebookAccounts =
                  state.socialAccountsModel.facebookDetails;
              final twitterAccounts = state.socialAccountsModel.twitterDetails;
              final List<Widget> listOfWidgets = [];

              if (instaAccount != null) {
                listOfWidgets.add(_buildInstaAccount(instaAccount));
              }
              if (facebookAccounts != null && facebookAccounts.isNotEmpty) {
                facebookAccounts.forEach((fbPage) =>
                    listOfWidgets.add(_buildFacebookAccounts(fbPage)));
              }
              if (twitterAccounts != null && twitterAccounts.isNotEmpty) {
                for (final account in twitterAccounts) {
                  listOfWidgets.add(_buildTwitterAccounts(account));
                }
              }
              if (isRemoving) {
                return Center(child: RLoader());
              }
              if (listOfWidgets.isNotEmpty) {
                return Column(
                  children: listOfWidgets,
                );
              } else {
                return Center(
                  child: state.isLoading
                      ? RLoader()
                      : RText(
                          state.error.isNotEmpty
                              ? "No account linked"
                              : "We are unable to fetch your details right now.",
                          variant: TypographyVariant.h1,
                        ),
                );
              }
            }),
          ],
        ),
      ],
    );
  }
}
