import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rasooc/domain/helper/enums.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/domain/models/campaign_detail_model.dart';
import 'package:rasooc/domain/models/campaign_short_model.dart';
import 'package:rasooc/domain/models/user_dependant_models.dart';
import 'package:rasooc/infra/resource/exceptions/exceptions.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';

class CampaignState with ChangeNotifier {
  GetIt getIt = GetIt.instance;
  bool _isLoading = false;
  String _error = "";
  List<CampaignShortModel> _listOfCampaigns = [];
  CampaignCategoryType _categoryType = CampaignCategoryType.all;
  List<CategoryModel> _allCategories = [];
  List<int> _userSelectedCategories = [];
  CampaignDetailModel _selectedCampaign = CampaignDetailModel();
  String _query = "";
  List<CampaignShortModel> _searchedCampaigns = [];
  String _appBarTitle = "All";

  ///`Getters`
  List<CampaignShortModel> get listOfCampaigns => _listOfCampaigns;
  bool get isLoading => _isLoading;
  String get error => _error;
  CampaignCategoryType get categoryType => _categoryType;
  List<CategoryModel> get allCategories => _allCategories;
  List<int> get userSelectedCategories => _userSelectedCategories;
  CampaignDetailModel get selectedCampaign => _selectedCampaign;
  String get query => _query;
  List<CampaignShortModel> get searchedCampaigns => _searchedCampaigns;
  String get appBarTitle => _appBarTitle;

  ///`Setters`
  void setCategoryType(CampaignCategoryType type) {
    _categoryType = type;
    _appBarTitle = type.asString()!;
    for (final item in _allCategories) {
      item.isSelected = false;
    }
    notifyListeners();
  }

  void setAllCategories(List<CategoryModel> list) {
    _allCategories = List<CategoryModel>.from(list);
    notifyListeners();
  }

  void addToUserSelectedCategories(CategoryModel model) {
    _userSelectedCategories.add(model.id!);
    notifyListeners();
  }

  void removeFromUserSelectedCategories(CategoryModel model) {
    _userSelectedCategories.removeWhere((element) => element == model.id);
    notifyListeners();
  }

  void searchCampaignQuery(String query) {
    if (_query != query) {
      _query = query;
      searchCampaigns();
      notifyListeners();
    }
  }

  void clearQuery() {
    _query = "";
    searchCampaigns();
    notifyListeners();
  }

  void clearSelectedCampaign() {
    _selectedCampaign = CampaignDetailModel();
    notifyListeners();
  }

  void setAppBarTitle(String title) {
    _appBarTitle = title;
    _allCategories.firstWhere((element) => element.name == title).isSelected =
        true;
    for (final cat in _allCategories) {
      if (cat.name != title) {
        cat.isSelected = false;
      }
    }
    notifyListeners();
  }

  ///`Api calls`

  ///Gets the list of [CampaignModel] for any influencer
  ///[limit] takes `int` value for `Pagination`
  Future<void> getCampaigns({int categoryId = 0, int limit = 1}) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      List<CampaignShortModel> list = [];

      if (categoryId != 0) {
        list = await gateway.getCampaigns(
            CampaignCategoryType.relevant.asId()!, [categoryId], limit);
      } else {
        list = await gateway.getCampaigns(
            _categoryType.asId()!, _userSelectedCategories, limit);
      }

      if (list.isNotEmpty) {
        _listOfCampaigns = List<CampaignShortModel>.from(list);
      } else {
        _listOfCampaigns = [];
      }
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      // log(error.toString(),
      //     name: "CampaignState-getCampaigns", stackTrace: stackTrace);
      _listOfCampaigns = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCampaignDetail(int campaignId) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      final model = await gateway.getCampaignDetail(campaignId);
      _selectedCampaign = model;
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "CampaignState-getCampaignDetail", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  ///Gets the detail of [CampaignModel] for any influencer
  ///where it takes `query` & gives all the search list
  Future<void> searchCampaigns() async {
    try {
      _error = "";
      List<CampaignShortModel> list = [];
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      if (query.isNotEmpty) {
        list = await gateway.searchCampaigns(_query.toLowerCase());
        _searchedCampaigns = List.from(list);
      } else {
        _searchedCampaigns = [];
      }
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _error = error.toString();
      // log(error.toString(),
      //     name: "CampaignState-searchCampaigns", stackTrace: stackTrace);
      _searchedCampaigns = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  ///`Duplicate function`
  Future<void> getCampaignCategories() async {
    try {
      _isLoading = true;
      _error = "";
      final gateway = getIt<ApiGateway>();
      final list = await gateway.getCampaginCategoires();
      if (list.isNotEmpty) {
        _allCategories = List.from(list);
      }
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "AutState-getCampaignCategories", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  ///Gets the detail of [CampaignModel] for any influencer
  ///where it takes `query` & gives all the search list
  Future<void> toggleFavoriteCampaign(bool isFav, int id) async {
    try {
      _error = "";

      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      if (id != 0) {
        final model = await gateway.favoriteCampgain(isFav, id);
        _listOfCampaigns
            .firstWhere((element) => element.id == model.id)
            .favourite = isFav;
      }

      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "CampaignState-toggleFavoriteCampaign", stackTrace: stackTrace);
      _searchedCampaigns = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> applyToCampaign(int? campaignId) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();

      final isApplied = await gateway.applyToCampaign(campaignId!);
      _isLoading = false;
      notifyListeners();
      return isApplied;
    } on ApiInternalServerException catch (apiError, stackTrace) {
      _error = "Some unexpected error occured! Please try agian later.";
      log(error.toString(),
          name: "CampaignState-applyToCampaign", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _error = e.toString();
      log(error.toString(),
          name: "CampaignState-applyToCampaign", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
