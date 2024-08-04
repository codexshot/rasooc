import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/domain/providers/social_account_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_divider.dart';
import 'package:rasooc/presentation/pages/auth/login.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/pages/profile-settings/widgets/account_settings.dart';
import 'package:rasooc/presentation/pages/profile-settings/widgets/social_accounts.dart';
import 'package:rasooc/presentation/pages/profile-settings/widgets/support_settings.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class ProfileSettingsScreen extends StatefulWidget {
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final ValueNotifier<String> _version = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    getAppVersion();
    getConnectedAccounts();
  }

  Future<void> getConnectedAccounts() async {
    final state = Provider.of<SocialAccountState>(context, listen: false);
    await state.getConnectedAccounts();
  }

  Future<void> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version.value = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              SizedBox(height: kToolbarHeight),
              _buildUserTopDetails().pH(20),
              RDivider(),
              _buildSocialAccounts().pH(20),
              RDivider(),
              _buildAccountSettings().pH(20),
              RDivider(),
              _buildSupport().pH(20),
              RDivider(),
              _buildLogout().pH(20),
              RDivider(),
              SizedBox(height: 10),
              _buildAppVersion().pH(20),
            ],
          ),
        ),
      ),
    );
  }

  ///`Building User Image & Details`
  Widget _buildUserTopDetails() {
    final profile = Provider.of<AuthState>(context).userProfile;
    final memberSince = profile.createdAt != null
        ? profile.createdAt!.getMemberSinceFromDate()
        : "DD MMM YEAR";
    print(profile.name);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: customNetworkImage(
            profile.profilePic,
            // "",
            height: 80,
            width: 80,
            defaultHolder: SvgPicture.asset(
              RImages.noUserImage,
              height: 80,
              width: 80,
            ),
          ),
        ),
        SizedBox(height: 10),
        RText(
          profile.name ??
              (profile.firstName ?? "N.A" + " " + profile.lastName!),
          // "HELLO",
          variant: TypographyVariant.titleSmall,
        ),
        SizedBox(height: 10),
        RText("Member since $memberSince", variant: TypographyVariant.h2),
        SizedBox(height: 10),
      ],
    );
  }

  ///`Building Social accounts that user added`
  Widget _buildSocialAccounts() {
    return ProfileSocialAccounts();
  }

  ///`Building account's  settings`
  Widget _buildAccountSettings() {
    return ProfileAccountSettings();
  }

  ///`Building Support`
  Widget _buildSupport() {
    return ProfileSupportSettings();
  }

  Widget _buildLogout() {
    return GestureDetector(
      onTap: () async {
        final state = Provider.of<AuthState>(context, listen: false);
        final bool isLogout = await state.logoutUser();
        if (isLogout) {
          NavigationHelpers.pushRemoveUntil(context, LoginPage());
          //TODO: CLEAR SHAREPREF
        } else {
          Utility.displaySnackbar(context,
              msg: "Can't logout right now : ${state.error}");
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Transform.rotate(
              angle: pi,
              child: Icon(
                Icons.logout,
                color: RColors.redColor,
              ),
            ),
            SizedBox(width: 10),
            RText(
              "Log Out",
              variant: TypographyVariant.h2,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppVersion() {
    return ValueListenableBuilder(
      valueListenable: _version,
      builder: (context, version, _) => Container(
        width: double.maxFinite,
        alignment: Alignment.centerLeft,
        child: RText(
          "App Version $version",
          variant: TypographyVariant.h2,
          style: TextStyle(
            color: RColors.secondaryColor,
          ),
        ),
      ),
    );
  }
}
