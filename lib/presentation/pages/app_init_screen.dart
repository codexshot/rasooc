import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_loader.dart';
import 'package:rasooc/presentation/themes/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/providers/account_settings_state.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';
import 'package:rasooc/infra/resource/service/notification_service.dart';
import 'package:rasooc/presentation/pages/auth/login.dart';
import 'package:rasooc/presentation/pages/bnb/bnb.dart';

class AppInitScreen extends StatefulWidget {
  @override
  _AppInitScreenState createState() => _AppInitScreenState();
}

class _AppInitScreenState extends State<AppInitScreen> {
  void checkNotifications() {
    final gateway = GetIt.instance<ApiGateway>();
    final pref = GetIt.instance<SharedPreferenceHelper>();

    Timer.periodic(Duration(minutes: 5), (Timer t) async {
      final list = await gateway.getNotifications();
      final prevLen = await pref.getNotificationLength();
      final newLen = list.length;

      if (prevLen != null && prevLen != newLen && (newLen - prevLen) > 1) {
        notificationService.scehduleNotification(
            prevLen, "Rasooc", list[newLen - 1].body!, "Notification payload");
      }
      await pref.setNotificationLength(newLen);
      print("NOTIFICATION -> YO");
    });
  }

  void checkMessages() {
    final gateway = GetIt.instance<ApiGateway>();
    final pref = GetIt.instance<SharedPreferenceHelper>();

    Timer.periodic(Duration(minutes: 1), (Timer t) async {
      final list = await gateway.getInfluencerChats();
      final prevLen = await pref.getMessagesLength();
      final newLen = list.length;
      final user = await pref.getUserProfile();
      final isMe = user?.userId == list[newLen - 1].userId;

      if (!isMe) {
        if (prevLen != null && prevLen != newLen && (newLen - prevLen) > 1) {
          notificationService.scehduleNotification(
              prevLen,
              list[newLen - 1].userName!,
              list[newLen - 1].comment!,
              "Message payload");
        }
      }
      await pref.setMessagesLength(newLen);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      doAutoLogin();

      // checkMessages();
    });
  }

  Future<void> intializeAppData() async {
    final fbId = await GetIt.instance<SharedPreferenceHelper>().getFBUserId();
    final fbAccessToken =
        await GetIt.instance<SharedPreferenceHelper>().getFBToken();

    final authState = Provider.of<AuthState>(context, listen: false);
    final accountState =
        Provider.of<AccountSettingsState>(context, listen: false);
    if (fbId != null) {
      await authState.checkUserExistUsingFBID(fbId, fbAccessToken);
      if (authState.userProfile.fbUserId != null) {
        accountState.setUserProfile(authState.userProfile);
        checkNotifications();

        NavigationHelpers.pushRelacement(context, RasoocBNB());
      } else {
        NavigationHelpers.pushRelacement(context, LoginPage());
      }
    } else {
      NavigationHelpers.pushRelacement(context, LoginPage());
    }
  }

  Future<void> doAutoLogin() async {
    final fbToken = await GetIt.instance<SharedPreferenceHelper>().getFBToken();
    final authState = Provider.of<AuthState>(context, listen: false);
    final isWhitelisted = await authState.goDaddyWhitelistIP();
    if (isWhitelisted) {
      if (fbToken != null && fbToken.isNotEmpty) {
        print("FBTOKEN -> $fbToken");
        final isvalid = await authState.checkAccessTokenStatus();
        if (isvalid) {
          await intializeAppData();
        } else {
          NavigationHelpers.pushRelacement(context, LoginPage());
        }
      } else {
        NavigationHelpers.pushRelacement(
            context,
            LoginPage(
              errorMessage:
                  "Some unexpected error occured while logging you in",
            ));
      }
    } else {
      NavigationHelpers.pushRelacement(
          context,
          LoginPage(
            errorMessage:
                "Please connect to Rasooc support for IP Whitelisting",
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: RColors.primaryColor,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 20.0),
              RText(
                "Loading...",
                variant: TypographyVariant.titleSmall,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ));
  }
}
