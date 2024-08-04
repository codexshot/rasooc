import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/routes.dart';
import 'package:rasooc/domain/providers/account_settings_state.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/domain/providers/campaign_state.dart';
import 'package:rasooc/domain/providers/chat_state.dart';
import 'package:rasooc/domain/providers/notification_state.dart';
import 'package:rasooc/domain/providers/post_state.dart';
import 'package:rasooc/domain/providers/social_account_state.dart';
import 'package:rasooc/domain/providers/submission_state.dart';
import 'package:rasooc/infra/drivers/errors.dart';
import 'package:rasooc/infra/resource/service/navigation_service.dart';

class RasoocApp extends StatefulWidget {
  final Widget? home;

  const RasoocApp({
    Key? key,
    @required this.home,
  }) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    // final _RasoocAppState state =
    //     context.findAncestorStateOfType<_RasoocAppState>()!;
  }

  @override
  _RasoocAppState createState() => _RasoocAppState();
}

class _RasoocAppState extends State<RasoocApp> {
  final _key = ErrorHandlerKey();
  ThemeData? appThemeData;
  // final _bloc = ErrorsBloc();

  @override
  void initState() {
    super.initState();

    GetIt.instance<ErrorsProducer>().registerErrorHandler(
      _key,
      (error, stackTrace) {
        log(error.toString(), stackTrace: stackTrace, name: "RasoocApp");
        // _bloc.add(OnError(error, stackTrace));
        // _navigatorKey.currentState.push(ErrorPageRoute());
        return false;
      },
    );

    getAppTheme();
  }

  @override
  void dispose() {
    GetIt.instance<ErrorsProducer>().unregisterErrorHandler(_key);
    // _bloc.close();
    super.dispose();
  }

  Future<void> getAppTheme() async {}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => AccountSettingsState()),
        ChangeNotifierProvider(create: (_) => CampaignState()),
        ChangeNotifierProvider(create: (_) => SocialAccountState()),
        ChangeNotifierProvider(create: (_) => SubmissionState()),
        ChangeNotifierProvider(create: (_) => PostState()),
        ChangeNotifierProvider(create: (_) => ChatState()),
        ChangeNotifierProvider(create: (_) => NotificationState()),
      ],
      child: MaterialAppWithTheme(
        navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
        home: widget.home,
      ),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;

  final Widget? home;

  const MaterialAppWithTheme({
    Key? key,
    @required this.navigatorKey,
    @required this.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      onGenerateTitle: (BuildContext context) => "Rasooc",

      home: home,
      // routes: Routes.routes,
      onGenerateRoute: Routes.onGenerateRoute,
      onUnknownRoute: Routes.onUnknownRoute,
    );
  }
}
