import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rasooc/domain/models/page_model.dart';
import 'package:rasooc/domain/models/social_accounts_model.dart';
import 'package:rasooc/infra/resource/exceptions/exceptions.dart';

import 'package:rasooc/infra/resource/service/api_gatway.dart';

class SocialAccountState extends ChangeNotifier {
  GetIt getIt = GetIt.instance;
  bool _isLoading = false;
  String _error = "";
  List<PageModel> _listOfFBPages = [];
  SocialAccountsModel _socialAccountsModel = SocialAccountsModel();
  InstaAccount _selectedInstaAccount = InstaAccount();
  FacebookPageAccount _selectedFBAccount = FacebookPageAccount();
  TwitterAccount _selectedTwitterAccount = TwitterAccount();

  ///`<<<<<========================Getters========================>>>>>`
  bool get isLoading => _isLoading;
  String get error => _error;
  List<PageModel> get listOfFBPages => _listOfFBPages;
  SocialAccountsModel get socialAccountsModel => _socialAccountsModel;
  InstaAccount get selectedInstaAccount => _selectedInstaAccount;
  FacebookPageAccount get selectedFBAccount => _selectedFBAccount;
  TwitterAccount get selectedTwitterAccount => _selectedTwitterAccount;

  ///`<<<<<========================Functions========================>>>>>`
  void setInstaAccount(InstaAccount instaAccount) {
    _selectedInstaAccount = instaAccount;
    _selectedFBAccount = FacebookPageAccount();
    _selectedTwitterAccount = TwitterAccount();
    notifyListeners();
  }

  void setFacebookAccount(FacebookPageAccount facebookPageAccount) {
    _selectedFBAccount = facebookPageAccount;
    _selectedInstaAccount = InstaAccount();
    _selectedTwitterAccount = TwitterAccount();
    notifyListeners();
  }

  void setTwitterAccount(TwitterAccount twitterAccount) {
    _selectedTwitterAccount = twitterAccount;
    _selectedInstaAccount = InstaAccount();
    _selectedFBAccount = FacebookPageAccount();
    notifyListeners();
  }

  void clearState() {
    _selectedInstaAccount = InstaAccount();
    _selectedFBAccount = FacebookPageAccount();
    _selectedTwitterAccount = TwitterAccount();
    notifyListeners();
  }

  ///`<<<<<========================API calls========================>>>>>`

  ///Adding `Facebook` account for the user
  ///using the FB access token
  Future<void> linkFacebookPages() async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final list = await gateway.linkFacebookPages();
      if (list.isNotEmpty) {
        _socialAccountsModel.facebookDetails = list;
      }
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "SocialAccountState-linkFacebookPages", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "SocialAccountState-linkFacebookPages", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  ///Adding `Instagram` account for the user
  ///using the FB access token
  Future<void> linkInstagramAccount() async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final insta = await gateway.linkInstagramAccount();
      if (insta.instagramId != null) {
        _socialAccountsModel.instaDetails = insta;
      }
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "SocialAccountState-linkInstagramAccount",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "SocialAccountState-linkInstagramAccount",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  ///Adding `Twitter` account for the user
  ///using the twitter
  Future<void> linkTwitterAccount() async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final account = await gateway.linkTwitterAccount();
      if (account.userId != null) {
        if (_socialAccountsModel.twitterDetails != null) {
          _socialAccountsModel.twitterDetails?.add(account);
        } else {
          _socialAccountsModel.twitterDetails = [account];
        }
      }
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "SocialAccountState-linkTwitterAccount",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "SocialAccountState-linkTwitterAccount",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getConnectedAccounts() async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      _socialAccountsModel = await gateway.getConnectedAccounts();
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "SocialAccountState-getConnectedAccounts",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "SocialAccountState-getConnectedAccounts",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removedConnectedAccount(int id,
      {bool isInsta = false, bool isFB = false, bool isTwitter = false}) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      if (isInsta) {
        _socialAccountsModel =
            await gateway.removeConnectedAccount(id, "instagram_id");
      }
      if (isFB) {
        _socialAccountsModel =
            await gateway.removeConnectedAccount(id, "pageid");
      }
      if (isTwitter) {
        _socialAccountsModel =
            await gateway.removeConnectedAccount(id, "twitter_id");
      }
      _isLoading = false;
      notifyListeners();
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "SocialAccountState-removedConnectedAccount",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "SocialAccountState-removedConnectedAccount",
          stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }
}
