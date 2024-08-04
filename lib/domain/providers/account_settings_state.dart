import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rasooc/domain/data/dummy_data.dart';
import 'package:rasooc/domain/models/geographic_entity.dart';
import 'package:rasooc/domain/models/profile_model.dart';
import 'package:rasooc/domain/models/user_dependant_models.dart';
import 'package:rasooc/infra/resource/service/api_gatway.dart';
import 'package:rasooc/presentation/themes/extensions.dart';

class AccountSettingsState with ChangeNotifier {
  GetIt getIt = GetIt.instance;
  bool _isLoading = false;

  late ProfileModel _userProfile;
  late ProfileModel _displayProfile; //only for displaying data on edit screen
  String _error = "";
  List<GeographicEntity> _listOfCountries = [];
  List<GeographicEntity> _listOfStates = [];
  List<GeographicEntity> _listOfCities = [];
  final List<GenderModel> _allGenders = DummyData.listOfGenders;

  ///`getters`
  ProfileModel get userProfile => _userProfile;
  ProfileModel get displayProfile => _displayProfile;
  String get error => _error;
  List<GeographicEntity> get listOfCountries => _listOfCountries;
  List<GeographicEntity> get listOfStates => _listOfStates;
  List<GeographicEntity> get listOfCities => _listOfCities;
  List<GenderModel> get allGenders => _allGenders;
  bool get isLoading => _isLoading;

  ///`setters`

  ///Set [ProfileModel] which is selected `user profile`
  ///from the [AuthState] when user creates account.
  void setUserProfile(ProfileModel profile) {
    _userProfile = profile;
    notifyListeners();
  }

  void setEditProfile() {
    _displayProfile = ProfileModel().copyFrom(_userProfile);
    _allGenders
        .firstWhere((element) => element.gender == _displayProfile.gender)
        .isSelected = true;
    notifyListeners();
  }

  void setFirstName(String value) {
    _displayProfile.firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _displayProfile.lastName = value;
    notifyListeners();
  }

  void setContactCell(String value) {
    _displayProfile.contactNumber = value;
    notifyListeners();
  }

  void setContactEmail(String value) {
    _displayProfile.email = value;
    notifyListeners();
  }

  void setResidentialArea(String value) {
    _displayProfile.residentialArea = value;
    notifyListeners();
  }

  void setStreetname(String value) {
    _displayProfile.street = value;
    notifyListeners();
  }

  void setPostalCode(String value) {
    _displayProfile.postalCode = value;
    notifyListeners();
  }

  void setDateOfBirth(DateTime date) {
    final birthday = date.dateConvertFromSystem();
    _displayProfile.birthday = birthday;
    notifyListeners();
  }

  void setSelectedCountry(GeographicEntity country) {
    _displayProfile.country = country;
    if (userProfile.country != _displayProfile.country) {
      _displayProfile.state = GeographicEntity(id: -1, name: "");
      _displayProfile.city = GeographicEntity(id: -1, name: "");
    }

    getStates();
    notifyListeners();
  }

  void setSelectedState(GeographicEntity state) {
    _displayProfile.state = state;
    if (userProfile.state != _displayProfile.state) {
      _displayProfile.city = GeographicEntity(id: -1, name: "");
    }
    getCities();
    notifyListeners();
  }

  void setSelectedCity(GeographicEntity city) {
    _displayProfile.city = city;
    clearCitySearchList();
    notifyListeners();
  }

  void setSelectedgender(int id) {
    for (final element in _allGenders) {
      if (element.id == id) {
        element.isSelected = true;
        _displayProfile.gender = element.gender;
      } else {
        element.isSelected = false;
      }
    }

    notifyListeners();
  }

  ///`Search Functionalities`
  //TODO: CHANGE THE LOGIC
  List<GeographicEntity> _displayCityList = [];
  List<GeographicEntity> get displayCityList => _displayCityList;

  void setCitySearchList(String? query) {
    if (query!.isEmpty) {
      _displayCityList = _listOfCities;
    } else {
      _displayCityList = _listOfCities
          .where(
              (city) => city.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  void clearCitySearchList() {
    _displayCityList = _listOfCities;
    notifyListeners();
  }

  void clearState() {
    _displayProfile = ProfileModel();
    notifyListeners();
  }

  Future<void> getLocations(String type, [int? arg]) async {
    try {
      _error = "";
      _isLoading = true;
      final gateway = getIt<ApiGateway>();

      if (type == "countries") {
        final model = await gateway.getCountries();
        if (model.isNotEmpty) {
          _listOfCountries = List.from(model, growable: false);
        }
      } else if (type == "states") {
        assert(arg != null);
        final model = await gateway.getStates(arg!);
        if (model.isNotEmpty) {
          _listOfStates = List.from(model, growable: false);
        }
      } else if (type == "cities") {
        assert(arg != null);
        final model = await gateway.getCities(arg!);
        if (model.isNotEmpty) {
          _listOfCities = List.from(model, growable: false);
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _isLoading = false;
      _error = error.toString();
      log(error.toString(),
          name: "AccountSettingState-getLocations-$type",
          stackTrace: stackTrace);
      notifyListeners();
    }
  }

  Future<void> getCountries() => getLocations("countries");
  Future<void> getStates() =>
      getLocations("states", _displayProfile.country?.id);
  Future<void> getCities() => getLocations("cities", _displayProfile.state?.id);

  Future<void> updateProfile() async {
    try {
      _isLoading = true;
      _error = "";
      final model = _displayProfile;
      final gateway = getIt<ApiGateway>();
      final profileModel = await gateway.updateUserProfile(model);
      if (profileModel.fbUserId != null) {
        _userProfile = profileModel;
        _displayProfile = profileModel;
      }
      _isLoading = false;
      notifyListeners();
    } catch (error, stackTrace) {
      _isLoading = false;

      _error = error.toString();
      log(error.toString(),
          name: "AccountSettingState-updateProfile", stackTrace: stackTrace);
      notifyListeners();
    }
  }
}
