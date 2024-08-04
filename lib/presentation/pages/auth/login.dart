import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/account_settings_state.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/overlay_loader.dart';
import 'package:rasooc/presentation/pages/auth/create_profile.dart';
import 'package:rasooc/presentation/pages/bnb/bnb.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';
import 'package:rasooc/presentation/themes/images.dart';

class LoginPage extends StatefulWidget {
  final String? errorMessage;

  const LoginPage({Key? key, this.errorMessage}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> loginToFb() async {
    _isLoading.value = true;
    final state = Provider.of<AuthState>(context, listen: false);
    final accountState =
        Provider.of<AccountSettingsState>(context, listen: false);
    final isWhitelisted = await state.goDaddyWhitelistIP();
    if (isWhitelisted) {
      await state.fbLoginUser();

      if (state.error.isEmpty && state.createUserProfile != null) {
        await state.checkUserExistUsingFBID(
            state.createUserProfile?.fbUserId ?? 0,
            state.createUserProfile?.fbAccessToken ?? "");

        if (state.userProfile.fbUserId != null) {
          accountState.setUserProfile(state.userProfile);
          NavigationHelpers.pushRelacement(context, RasoocBNB());
        } else {
          print("--------------------");
          state.initializeDataFromFacebook();
          NavigationHelpers.pushRelacement(context, CreateProfilePage());
        }
      } else {
        _isLoading.value = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error logging in : ${state.error})")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Error logging in : Please contact rasooc support for whitelisting IP"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfUnauthorized();
  }

  Future<void> checkIfUnauthorized() async {
    if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) {
      await Future.delayed(Duration(seconds: 1), () {
        Utility.displaySnackbar(context,
            msg: widget.errorMessage!, key: _scaffoldKey);
      });
    }
  }

  Widget _buildItem() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(RImages.onBoardingLogin),
        SizedBox(height: 20.0),
        RText(
          "Login",
          variant: TypographyVariant.titleSmall,
          style: TextStyle(
            color: RColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20.0),
        RText(
          '',
          variant: TypographyVariant.h3,
          style: TextStyle(
            color: RColors.disableColor,
          ),
        ).pAll(10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight + 30),
              child: SvgPicture.asset(
                RImages.splashLogo,
              ),
            ),
          ),
          _buildItem().pH(20),
          Positioned(
            bottom: 40.0,
            left: 0.0,
            right: 0.0,
            child: Column(
              children: [
                FlatButton(
                  color: const Color(0xff395795),
                  padding: EdgeInsets.symmetric(vertical: 22.0),
                  textColor: Colors.white,
                  minWidth: double.maxFinite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: loginToFb,
                  child: const Text('LOG IN WITH FACEBOOK'),
                ),
                SizedBox(height: 10),
                Text(
                  'Log in to use Facbook, instagram & twitter accounts\nT&Cs and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xff747880),
                    fontSize: 10,
                  ),
                ),
              ],
            ).pH(20),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, isLoading, _) => isLoading
                ? OverlayLoading(
                    showLoader: _isLoading,
                    loadingMessage: "Logging In",
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
