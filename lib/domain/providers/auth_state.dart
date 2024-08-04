import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rasooc/domain/data/dummy_data.dart';
import 'package:rasooc/domain/helper/shared_pref_helper.dart';
import 'package:rasooc/domain/models/access_token_model.dart';
import 'package:rasooc/domain/models/account_response_model.dart';
import 'package:rasooc/domain/models/geographic_entity.dart';
import 'package:rasooc/domain/models/location_response_model.dart';
import 'package:rasooc/domain/models/profile_model.dart';
import 'package:rasooc/domain/models/user_dependant_models.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthState with ChangeNotifier {
  GetIt getIt = GetIt.instance;
  bool _isLoading = false;
  ProfileModel? _createUserProfile;
  ProfileModel _userProfile = ProfileModel();
  String _error = "";
  GeographicEntity _selectedCountry = GeographicEntity(id: -1, name: "");
  GeographicEntity _selectedState = GeographicEntity(id: -1, name: "");
  GeographicEntity _selectedCity = GeographicEntity(id: -1, name: "");
  String _userAge = "";
  List<CategoryModel> _allCategories = [];
  final List<CategoryModel> _userLikedCategories = [];
  GenderModel _selectedGender = GenderModel(
    id: 0,
    gender: "Select your gender",
  );
  final List<GenderModel> _allGenders = DummyData.listOfGenders;
  // List<StateModel> _listOfStates = [];
  List<GeographicEntity> _listOfCountries = [];
  List<GeographicEntity> _listOfStates = [];
  List<GeographicEntity> _listOfCities = [];

  ///`Getters`
  ProfileModel? get createUserProfile => _createUserProfile;
  ProfileModel get userProfile => _userProfile;
  String get error => _error;
  GeographicEntity get selectedCountry => _selectedCountry;
  GeographicEntity get selectedState => _selectedState;
  GeographicEntity get selectedCity => _selectedCity;
  List<CategoryModel> get userLikedCategories => _userLikedCategories;
  List<CategoryModel> get allCategories => _allCategories;
  List<GenderModel> get allGenders => _allGenders;
  GenderModel get selectedGender => _selectedGender;
  String get userAge => _userAge;
  // List<StateModel> get listOfStates => _listOfStates;
  bool get isLoading => _isLoading;
  List<GeographicEntity> get listOfCountries => _listOfCountries;
  List<GeographicEntity> get listOfStates => _listOfStates;
  List<GeographicEntity> get listOfCities => _listOfCities;

  ///`setters`
  void initializeDataFromFacebook() {
    // selectedCity = userProfile.city!;
    if (_createUserProfile?.gender != null) {
      _selectedGender = allGenders.firstWhere((element) =>
          element.gender?.toLowerCase() ==
          _createUserProfile?.gender?.toLowerCase())
        ..isSelected = true;
    }

    notifyListeners();
  }

  void setUserAge(String age) {
    _createUserProfile!.age = age;
    notifyListeners();
  }

  void setSelectedCountry(GeographicEntity country) {
    if (_selectedCountry.id != country.id) {
      getStates(country.id);
      _selectedCountry = country;
      clearCountrySearchList();
      notifyListeners();
    }
  }

  void setSelectedState(GeographicEntity state) {
    if (_selectedState.id != state.id) {
      getCities(state.id);
      _selectedState = state;
      clearStateSearchList();
      notifyListeners();
    }
  }

  void setSelectedCity(GeographicEntity city) {
    if (_selectedCity.id != city.id) {
      _selectedCity = city;
      clearCitySearchList();
      notifyListeners();
    }
  }

  void setFirstName(String firstname) {
    _createUserProfile!.firstName = firstname;
    notifyListeners();
  }

  void setLastName(String lastName) {
    _createUserProfile!.lastName = lastName;
    notifyListeners();
  }

  void setEmail(String email) {
    _createUserProfile!.email = email;
    notifyListeners();
  }

  void toggleCategorySelection(int id) {
    final model = _allCategories.firstWhere((element) => element.id == id);
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
      _userLikedCategories.add(model);
    } else {
      _userLikedCategories.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }

  void setSelectedgender(int id) {
    for (final element in _allGenders) {
      if (element.id == id) {
        element.isSelected = true;
        _selectedGender = element;
      } else {
        element.isSelected = false;
      }
    }

    notifyListeners();
  }

  ///`Search Functionalities`
  List<GeographicEntity> _displayCountryList = [];
  List<GeographicEntity> get displayCountryList => _displayCountryList;
  List<GeographicEntity> _displayStateList = [];
  List<GeographicEntity> get displayStateList => _displayStateList;
  List<GeographicEntity> _displayCityList = [];
  List<GeographicEntity> get displayCityList => _displayCityList;

  void setCountrySearchList(String? query) {
    if (query!.isEmpty) {
      _displayCountryList = listOfCountries;
    } else {
      _displayCountryList = listOfCountries
          .where((country) =>
              country.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  void clearCountrySearchList() {
    _displayCountryList = listOfCountries;
    notifyListeners();
  }

  void setStateSearchList(String? query) {
    if (query!.isEmpty) {
      _displayStateList = listOfStates;
    } else {
      _displayStateList = listOfStates
          .where(
              (state) => state.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  void clearStateSearchList() {
    _displayStateList = listOfStates;
    notifyListeners();
  }

  void setCitySearchList(String? query) {
    if (query!.isEmpty) {
      _displayCityList = listOfCities;
    } else {
      _displayCityList = listOfCities
          .where(
              (city) => city.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  void clearCitySearchList() {
    _displayCityList = listOfCities;
    notifyListeners();
  }

  void clearState() {
    _createUserProfile = ProfileModel();
    _error = "";
    _selectedState = GeographicEntity(id: -1, name: "");
    _selectedCity = GeographicEntity(id: -1, name: "");
    _userAge = "";
    _userLikedCategories.clear();
    _selectedGender = GenderModel();
    _allGenders.clear();
    _listOfStates.clear();
  }

  ///`<<<<-------------------API calls------------------->>>>`

  ///`Login user to Facebook`
  Future<void> fbLoginUser() async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();
      _createUserProfile = await gateway.fbLoginUser();
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _isLoading = false;
      _error = error.toString();
      log(error.toString(), name: "AutState-Login", stackTrace: stackTrace);
      notifyListeners();
    }
  }

  Future<bool> checkAccessTokenStatus() async {
    try {
      _isLoading = true;
      _error = "";
      final gateway = getIt<ApiGateway>();
      final AccessTokenModel accessTokenModel =
          await gateway.checkAccessTokenStatus();
      _isLoading = false;
      notifyListeners();
      return accessTokenModel.data!.isValid!;
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(), name: "AutState-Login", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logoutUser() async {
    try {
      _isLoading = true;
      _error = "";
      final gateway = getIt<ApiGateway>();
      final isLogout = await gateway.logoutUser();
      await getIt<SharedPreferenceHelper>().clearAll();
      _isLoading = false;
      notifyListeners();
      return isLogout;
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(), name: "AutState-Logout", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> createAccount() async {
    try {
      _isLoading = true;
      _error = "";
      final gateway = getIt<ApiGateway>();
      final pref = getIt<SharedPreferenceHelper>();
      final fbId = await pref.getFBUserId();
      final model = ProfileModel(
        firstName: _createUserProfile!.firstName,
        lastName: _createUserProfile!.lastName,
        name: createUserProfile!.firstName! + createUserProfile!.lastName!,
        // city: _selectedCity,
        fbUserId: fbId,
        country: _selectedCountry,
        state: _selectedState,
        city: _selectedCity,
        age: _createUserProfile!.age,
        birthday: _createUserProfile!.birthday,
        email: _createUserProfile!.email,
        gender: _selectedGender.gender,
        hometown: _createUserProfile!.hometown,
        profilePic: _createUserProfile!.profilePic,
        fbAccessToken: _createUserProfile!.fbAccessToken,
        contactNumber: null,
        categories: List.from(_userLikedCategories),
      );

      final AccountResponseModel accountResponseModel =
          await gateway.createUserAccount(model);
      if (accountResponseModel.error != null &&
          accountResponseModel.error!.isNotEmpty) {
        _error = accountResponseModel.error!;
        return;
      } else {
        //if success
        _userProfile = accountResponseModel.model!;
        _userProfile.userAccessToken = accountResponseModel.accessToken;
        _userProfile.name =
            "${_userProfile.firstName ?? ""} ${_userProfile.lastName ?? ""}";
        userProfile.country = selectedCountry;
        userProfile.state = selectedCity;
        userProfile.city = selectedCity;
        _userProfile.categories = List.from(_userLikedCategories);

        if (_userProfile.fbAccessToken != null &&
            _userProfile.fbAccessToken != null) {
          await pref.setFBToken(_userProfile.fbAccessToken!);
          await pref.setAccessToken(accountResponseModel.accessToken!);
          await pref.setUserProfile(_userProfile);
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "AutState-CreateAccount", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCountries() async {
    try {
      _isLoading = true;
      _error = "";
      final gateway = getIt<ApiGateway>();
      final model = await gateway.getCountries();
      if (model.isNotEmpty) {
        _listOfCountries = List.from(model);
        _displayCountryList = listOfCountries;
      }
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "AutState-getLocations", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStates(int countryId) async {
    try {
      _isLoading = true;
      _error = "";
      final gateway = getIt<ApiGateway>();
      final model = await gateway.getStates(countryId);
      if (model.isNotEmpty) {
        _listOfStates =
            List.from(model..sort((a, b) => a.name.compareTo(b.name)));
        _displayStateList = listOfStates;
      }
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "AutState-getLocations", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCities(int stateId) async {
    try {
      _isLoading = true;
      _error = "";
      final gateway = getIt<ApiGateway>();
      final model = await gateway.getCities(stateId);
      if (model.isNotEmpty) {
        _listOfCities = List.from(model);
        _displayCityList = listOfCities;
      }
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "AutState-getLocations", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

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

  ///Getting user profile using Token
  Future<void> getUserProfile() async {
    try {
      _error = "";
      final gateway = getIt<ApiGateway>();

      final profile = await gateway.getUserProfile();
      _userProfile = profile;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "AutState-getUserProfile", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addInstaAccount() async {
    try {
      _isLoading = true;
      _error = "";
      final gateway = getIt<ApiGateway>();
      await gateway.addInstaAccount();
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(), name: "AutState-INSTA", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkUserExistUsingFBID(int fbId, String? fbAccessToken) async {
    try {
      _error = "";
      final gateway = getIt<ApiGateway>();
      if (fbId != 0) {
        final profile =
            await gateway.checkUserExistUsingFBID(fbId, fbAccessToken);
        _userProfile = profile;
      }
      notifyListeners();
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "AutState-checkUserExistUsingFBID", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> launchUrl(String url) async {
    try {
      _error = "";
      final isLaunched = await canLaunch(url);
      if (isLaunched) {
        await launch(url);
      } else {
        _error = "Some unexpected error occurred while launching";
      }
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "AutState-checkUserExistUsingFBID", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
    }
  }

  ///`IMPORTANT`
  ///This is work around for whitelisting IPs in goDaddy
  ///Untill you found a better way use this one.
  Future<bool> goDaddyWhitelistIP() async {
    try {
      _error = "";
      final gateway = getIt<ApiGateway>();
      final isWhiteListed = await gateway.goDaddyWhitelistIp();
      if (isWhiteListed) {
        notifyListeners();
        return true;
      } else {
        _error = "Some unexpected error occurred while launching";
        notifyListeners();
        return false;
      }
    } catch (error, stackTrace) {
      _error = error.toString();
      log(error.toString(),
          name: "AutState-goDaddyWhitelistIP", stackTrace: stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
