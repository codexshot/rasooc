import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/config.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/infra/drivers/errors.dart';
import 'package:rasooc/infra/resource/dio_client.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';
import 'package:rasooc/infra/resource/service/api_gatway_dev.dart';
import 'package:rasooc/infra/resource/service/api_gatway_impl.dart';
import 'package:rasooc/infra/resource/service/navigation_service.dart';
import 'package:rasooc/infra/resource/service/notification_service.dart';
import 'package:rasooc/presentation/pages/chat/chat_screen.dart';

void setUpDependency(Config config) {
  final serviceLocator = GetIt.instance;

  serviceLocator.registerSingleton<ErrorsProducer>(ErrorsProducer());
  if (config.dummyData!) {
    serviceLocator.registerSingleton<ApiGateway>(ApiGatewayDev(
      DioClient(Dio(), baseEndpoint: config.apiBaseUrl, logging: true),
    ));
  } else {
    serviceLocator.registerSingleton<ApiGateway>(
      ApiGatewayImpl(
        DioClient(Dio(), baseEndpoint: config.apiBaseUrl, logging: true),
      ),
    );
  }

  ///Register all `singletons` here
  serviceLocator
      .registerSingleton<SharedPreferenceHelper>(SharedPreferenceHelper());
  serviceLocator.registerSingleton<NavigationService>(NavigationService());

  notificationService.setListenerForLowerVersions(onNotificaitonOnLowerVersion);
  notificationService.setNotificationOnClick(onNotificationClick);
}

void onNotificaitonOnLowerVersion(
    ReceivedNotifications receivedNotifications) {}

void onNotificationClick(String payload) {
  NavigationService().navigateTo(ChatScreen());
}
