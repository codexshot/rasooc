import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/size_configs.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/models/icon_model.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/domain/providers/social_account_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/overlay_loader.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class ProfileSelectPlatform extends StatefulWidget {
  @override
  _ProfileSelectPlatformState createState() => _ProfileSelectPlatformState();
}

class _ProfileSelectPlatformState extends State<ProfileSelectPlatform> {
  late List<PlatformIconModel> _listOfPlatforms;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    initalizeList();
  }

  @override
  void dispose() {
    _isLoading.dispose();
    super.dispose();
  }

  Future<void> addInstaAccount() async {
    _isLoading.value = true;
    final state = Provider.of<SocialAccountState>(context, listen: false);
    await state.linkInstagramAccount();
    _isLoading.value = false;

    if (state.error.isNotEmpty) {
      Utility.displaySnackbar(context, msg: state.error, key: _scaffoldKey);
    }
    if (state.socialAccountsModel.instaDetails?.instagramId != null) {
      Utility.displaySnackbar(context,
          msg: "Insta Account linked successfully", key: _scaffoldKey);
    }
  }

  Future<void> linkFacebookPages() async {
    _isLoading.value = true;
    final state = Provider.of<SocialAccountState>(context, listen: false);
    await state.linkFacebookPages();
    _isLoading.value = false;

    if (state.error.isNotEmpty) {
      Utility.displaySnackbar(context, msg: state.error, key: _scaffoldKey);
    }
    if (state.socialAccountsModel.facebookDetails != null &&
        state.socialAccountsModel.facebookDetails!.isNotEmpty) {
      Utility.displaySnackbar(context,
          msg: "FB Pages linked successfully", key: _scaffoldKey);
    }
  }

  Future<void> addTwitterAccount() async {
    _isLoading.value = true;
    final state = Provider.of<SocialAccountState>(context, listen: false);
    await state.linkTwitterAccount();
    _isLoading.value = false;

    if (state.error.isNotEmpty) {
      Utility.displaySnackbar(context, msg: state.error, key: _scaffoldKey);
    } else {
      Utility.displaySnackbar(context,
          msg: "Twitter account linked successfully", key: _scaffoldKey);
    }
  }

  void initalizeList() {
    _listOfPlatforms = [
      PlatformIconModel(
        title: "Facebook",
        imagepathSvg: RImages.facebookLogo,
        onPressed: () {
          linkFacebookPages();
        },
      ),
      PlatformIconModel(
        title: "Instagram",
        imagepathSvg: RImages.instaLogo,
        onPressed: () {
          addInstaAccount();
        },
      ),
      PlatformIconModel(
        title: "Twitter",
        imagepathSvg: RImages.twitterLogo,
        onPressed: () {
          addTwitterAccount();
        },
      ),
    ];
  }

  Widget _buildPlatformTile(PlatformIconModel platform) {
    return GestureDetector(
      onTap: () {
        platform.onPressed!();
      },
      child: Container(
        width: sizeConfig.safeWidth! * 26,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: RColors.secondaryColor, width: 0.5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: RColors.lineColor,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            SvgPicture.asset(platform.imagepathSvg!),
            SizedBox(height: 10),
            RText(
              platform.title!,
              variant: TypographyVariant.h1,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              size: 30,
              color: Colors.grey,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ).pH(20),
        ],
      ),
      body: SafeArea(
        child: Consumer<SocialAccountState>(
          builder: (context, state, _) => Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RText(
                    "Select Platform",
                    variant: TypographyVariant.titleSmall,
                    style: TextStyle(fontSize: 23),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _listOfPlatforms
                        .map((platform) => _buildPlatformTile(platform))
                        .toList(),
                  )
                ],
              ).pAll(10),
              ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (BuildContext context, bool value, _) {
                  return value
                      ? OverlayLoading(
                          showLoader: _isLoading,
                          loadingMessage: "Linking...",
                        )
                      : SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
