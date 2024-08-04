import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rasooc/domain/models/chat_model.dart';
import 'package:rasooc/infra/resource/exceptions/exceptions.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';

class ChatState with ChangeNotifier {
  GetIt getIt = GetIt.instance;
  bool _isLoading = false;
  String _error = "";

  ///`<<<<<========================Getters========================>>>>>`
  bool get isLoading => _isLoading;
  String get error => _error;

  ///`<<<<<========================Functions========================>>>>>`

  ///`<<<<<========================API calls========================>>>>>`
  Future<List<ChatModel>> getSubmissionComments(int submissionId) async {
    try {
      _error = "";
      List<ChatModel> _list = [];
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final list = await gateway.getSubmissionComments(submissionId);
      if (list.isNotEmpty) {
        _list = List.from(list);
      }

      print("FROM PROVIDER -> ${_list.length}");

      _isLoading = false;
      notifyListeners();
      return _list;
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "ChatState-getSubmissionList", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return [];
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "ChatState-getSubmissionList", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  Future<List<ChatModel>> submitComment(
      int submissionId, String message) async {
    try {
      _error = "";
      List<ChatModel> _list = [];
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final list = await gateway.postComment(submissionId, message);
      if (list.isNotEmpty) {
        _list = List.from(list);
      }
      _isLoading = false;
      notifyListeners();
      return _list;
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "ChatState-getSubmissionList", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return [];
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "ChatState-getSubmissionList", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  ///Normal chat/messages from Influecner - Brand
  Future<List<ChatModel>> getInfluencerChats() async {
    try {
      _error = "";
      List<ChatModel> _list = [];
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final list = await gateway.getInfluencerChats();
      if (list.isNotEmpty) {
        _list = List.from(list);
      }

      print("FROM PROVIDER -> ${_list.length}");

      _isLoading = false;
      notifyListeners();
      return _list;
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "ChatState-getInfluencerChats", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return [];
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "ChatState-getInfluencerChats", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  //Influencer send's chat
  Future<List<ChatModel>> sendInfluencerChat(String message) async {
    try {
      _error = "";
      List<ChatModel> _list = [];
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final list = await gateway.sendInfluencerChat(message);
      if (list.isNotEmpty) {
        _list = List.from(list);
      }
      _isLoading = false;
      notifyListeners();
      return _list;
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "ChatState-sendInfluencerChat", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return [];
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "ChatState-sendInfluencerChat", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }
}
