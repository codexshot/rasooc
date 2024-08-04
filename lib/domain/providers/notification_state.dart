import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/models/notifications_model.dart';
import 'package:rasooc/infra/resource/exceptions/exceptions.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';

class NotificationState with ChangeNotifier {
  GetIt getIt = GetIt.instance;
  bool _isLoading = false;
  String _error = "";
  List<NotificationsModel> _notifications = [];

  ///`<<<<<========================Getters========================>>>>>`
  bool get isLoading => _isLoading;
  String get error => _error;
  List<NotificationsModel> get notifications => _notifications;

  ///`<<<<<========================Functions========================>>>>>`

  void removeNotification(NotificationDecision decision, {int id = 0}) {
    if (decision == NotificationDecision.all) {
      _notifications.clear();
      notifyListeners();
    } else {
      _notifications.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }

  ///`<<<<<========================API calls========================>>>>>`

  Future<void> getNotifications() async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final list = await gateway.getNotifications();
      if (list.isNotEmpty) {
        _notifications = List.from(list);
      }
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "NotificationState-getNotifications", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "NotificationState-getNotifications", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> clearNotifications(NotificationDecision decision,
      {int id = 0}) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final isCleared = await gateway.clearNotification(decision, id);
      if (isCleared) {
        removeNotification(decision, id: id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "NotificationState-clearNotifications", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "NotificationState-clearNotifications", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
