import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/domain/models/onboarding_model.dart';
import 'package:rasooc/domain/providers/account_settings_state.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/overlay_loader.dart';
import 'package:rasooc/presentation/pages/auth/create_profile.dart';
import 'package:rasooc/presentation/pages/bnb/bnb.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:rasooc/presentation/themes/images.dart';
import 'package:rasooc/presentation/themes/extensions.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final CarouselController _carouselController = CarouselController();

  Future<void> loginToFb() async {
    _isLoading.value = true;
    final state = Provider.of<AuthState>(context, listen: false);
    final accountState =
        Provider.of<AccountSettingsState>(context, listen: false);
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
  }

  final List<OnBoardingModel> list = [
    OnBoardingModel(
      title: "Create",
      imagePath: RImages.onBoardingCreate,
      subText: "",
    ),
    OnBoardingModel(
      title: "Publish",
      imagePath: RImages.onBoardingPublish,
      subText: "",
    ),
    OnBoardingModel(
      title: "Earn",
      imagePath: RImages.onBoardingEarn,
      subText: "",
    ),
    OnBoardingModel(
      title: "Login",
      imagePath: RImages.onBoardingLogin,
      subText: "",
    )
  ];

  @override
  void initState() {
    super.initState();
    setOnboardedTrue();
  }

  Future<void> setOnboardedTrue() async {
    SharedPreferenceHelper().setOnboarded(onboarded: true);
  }

  Widget _buildItem({required OnBoardingModel model, required int index}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(model.imagePath!),
        SizedBox(height: 20.0),
        RText(
          model.title!,
          variant: TypographyVariant.titleSmall,
          style: TextStyle(
            color: RColors.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20.0),
        RText(
          model.subText!,
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
            Align(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CarouselSlider(
                    carouselController: _carouselController,
                    items: list
                        .asMap()
                        .entries
                        .map((mapEntry) => _buildItem(
                            model: mapEntry.value, index: mapEntry.key))
                        .toList(),
                    options: CarouselOptions(
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      aspectRatio: 1,
                      onPageChanged: (index, _) {
                        _currentPageNotifier.value = index;
                      },
                    ),
                  ),
                  // SizedBox(height: 20.0),
                  SizedBox(
                    height: 8.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => ValueListenableBuilder(
                              valueListenable: _currentPageNotifier,
                              builder: (context, selectedIndex, child) =>
                                  Container(
                                height: 8.0,
                                width: 8.0,
                                margin: EdgeInsets.symmetric(horizontal: 2.0),
                                decoration: BoxDecoration(
                                    color: selectedIndex == index
                                        ? RColors.primaryColor
                                        : RColors.disableColor,
                                    borderRadius: BorderRadius.circular(4.0)),
                              ),
                            )),
                  ),
                ],
              ).pH(20),
            ),
            ValueListenableBuilder(
              valueListenable: _currentPageNotifier,
              builder: (context, selectedIndex, child) =>
                  selectedIndex == list.length - 1
                      ? Positioned(
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
                          ).pH(20))
                      : Positioned(
                          right: 40.0,
                          bottom: 40.0,
                          child: GestureDetector(
                            onTap: () {
                              _carouselController.animateToPage(
                                  _currentPageNotifier.value + 1);
                              setState(() {
                                _currentPageNotifier.value += 1;
                              });
                            },
                            child: RText(
                              "Next",
                              variant: TypographyVariant.h1,
                              style: TextStyle(color: RColors.secondaryColor),
                            ),
                          )),
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
        ));
  }
}
