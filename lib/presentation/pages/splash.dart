import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/presentation/pages/app_init_screen.dart';
import 'package:rasooc/presentation/pages/no_internet_screen.dart';
import 'package:rasooc/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/images.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    moveToAppLoadingState();
  }

  Future<void> moveToAppLoadingState() async {
    final isOnboarded = await SharedPreferenceHelper().getIfOnboarded();
    if (isOnboarded != null && isOnboarded) {
      final bool hasConnection = await Utility.hasInternetConnection();
      setState(() {});
      await Future.delayed(
        Duration(milliseconds: 500),
        () {
          if (hasConnection) {
            NavigationHelpers.pushRelacement(context, AppInitScreen());
          } else {
            NavigationHelpers.pushRelacement(context, NoInternetConnection());
          }
        },
      );
    } else {
      NavigationHelpers.pushRelacement(context, OnBoardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: RColors.primaryColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              RImages.splashLogo,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
