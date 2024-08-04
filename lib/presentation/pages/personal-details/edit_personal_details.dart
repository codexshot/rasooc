import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/navigation_helper.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/account_settings_state.dart';
import 'package:rasooc/presentation/common-widgets/common.dart';
import 'package:rasooc/presentation/common-widgets/custom_selection_field.dart';
import 'package:rasooc/presentation/common-widgets/overlay_loader.dart';
import 'package:rasooc/presentation/common-widgets/custom_cached_image.dart';
import 'package:rasooc/presentation/pages/personal-details/widgets/edit_city_screen.dart';
import 'package:rasooc/presentation/pages/personal-details/widgets/edit_gender_screen.dart';
import 'package:rasooc/presentation/pages/personal-details/widgets/edit_location_screen.dart';
import 'package:rasooc/presentation/themes/common_themes.dart';

class EditPersonalDetails extends StatefulWidget {
  @override
  _EditPersonalDetailsState createState() => _EditPersonalDetailsState();
}

class _EditPersonalDetailsState extends State<EditPersonalDetails> {
  late TextEditingController _contactController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _genderController;
  late TextEditingController _lastNameController;
  late TextEditingController _postalController;
  late TextEditingController _residentialController;
  late TextEditingController _streetController;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _residentialController.dispose();
    _streetController.dispose();
    _postalController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    final state = Provider.of<AccountSettingsState>(context, listen: false);
    final user = state.displayProfile;

    _firstNameController = TextEditingController(text: user.firstName);
    _lastNameController = TextEditingController(text: user.lastName);
    _contactController = TextEditingController(text: user.contactNumber);
    _emailController = TextEditingController(text: user.email);
    _genderController = TextEditingController(text: user.gender);
    _residentialController = TextEditingController(text: user.residentialArea);
    _streetController = TextEditingController(text: user.street);
    _postalController = TextEditingController(text: user.postalCode);
    await state.getCountries();
    await state.getStates();
    await state.getCities();
  }

  void onPop() async {
    Navigator.of(context).pop();
    await Future.delayed(Duration(milliseconds: 300));
    Provider.of<AccountSettingsState>(context, listen: false).clearState();
  }

  void saveUserDetails() async {
    _formKey.currentState!.save();
    final state = Provider.of<AccountSettingsState>(context, listen: false);
    final displayProfile = state.displayProfile;

    bool isValidated = _formKey.currentState!.validate();
    if (isValidated &&
        displayProfile.state!.name.isNotEmpty &&
        displayProfile.city!.name.isNotEmpty) {
      _isLoading.value = true;
      print("TRUE CALL SAVING API");
      await state.updateProfile();
      if (state.error.isNotEmpty) {
        _isLoading.value = false;
        Utility.displaySnackbar(context,
            key: _scaffoldKey,
            msg:
                "Something went wrong while updating your profile. Please try again later");
      } else {
        onPop();
        _isLoading.value = false;
      }
    } else {
      if (!isValidated) {
        return;
      } else {
        if (displayProfile.state!.name.isEmpty) {
          Utility.displaySnackbar(context,
              key: _scaffoldKey, msg: "Please select a state to continue");
        } else {
          Utility.displaySnackbar(context,
              key: _scaffoldKey, msg: "Please select a city to continue");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountState =
        Provider.of<AccountSettingsState>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        onPop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: () => onPop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: RColors.secondaryColor,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                saveUserDetails();
              },
              child: RText("Save", variant: TypographyVariant.h1).pAll(20),
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: customNetworkImage(
                                accountState.displayProfile.profilePic,
                                height: 80,
                                width: 80,
                                defaultHolder: SvgPicture.asset(
                                  RImages.userImage,
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            RText(
                              "Edit Personal Details",
                              variant: TypographyVariant.title,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RTextField(
                            choice: Choice.name,
                            controller: _firstNameController,
                            labelText: "First name",
                            onChanged: (value) {
                              accountState.setFirstName(value);
                            },
                          ).pAll(12),
                          RTextField(
                            choice: Choice.name,
                            controller: _lastNameController,
                            labelText: "Last name",
                            onChanged: (value) {
                              accountState.setLastName(value);
                            },
                          ).pAll(12),
                          RTextField(
                            choice: Choice.phone,
                            controller: _contactController,
                            labelText: "Contact cell",
                            onChanged: (value) {
                              accountState.setContactCell(value);
                            },
                          ).pAll(12),
                          RTextField(
                            choice: Choice.email,
                            controller: _emailController,
                            labelText: "Contact email",
                            onChanged: (value) {
                              accountState.setContactEmail(value);
                            },
                          ).pAll(12),
                          Consumer<AccountSettingsState>(
                              builder: (context, authState, child) {
                            final String stateName =
                                authState.displayProfile.gender != null &&
                                        authState
                                            .displayProfile.gender!.isNotEmpty
                                    ? authState.displayProfile.gender!
                                    : "Gender";
                            final bool isEmpty =
                                !(authState.displayProfile.gender != null &&
                                    authState
                                        .displayProfile.gender!.isNotEmpty);

                            return RSelectionField(
                              onpressed: () {
                                NavigationHelpers.push(
                                    context, EditGenderScreen());
                              },
                              text: stateName,
                              isEmpty: isEmpty,
                            ).pAll(12);
                          }),
                          Consumer<AccountSettingsState>(
                            builder: (context, state, child) {
                              final user = state.displayProfile;

                              return RSelectionField(
                                text: user.birthday ?? "Date of birth",
                                onpressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1960),
                                    lastDate: DateTime.now(),
                                    confirmText: "DONE",
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          primaryColor: RColors.primaryColor,
                                          accentColor: RColors.primaryColor,
                                          colorScheme: ColorScheme.light(
                                              primary: RColors.primaryColor),
                                          dialogBackgroundColor: Colors.white,
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (date != null) {
                                    state.setDateOfBirth(date);
                                  }
                                },
                              ).pAll(12);
                            },
                          ),
                          RTextField(
                            choice: Choice.optionalText,
                            controller: _residentialController,
                            labelText: "Residential area",
                            onChanged: (value) {
                              accountState.setResidentialArea(value);
                            },
                          ).pAll(12),
                          Consumer<AccountSettingsState>(
                              builder: (context, authState, child) {
                            final String countryName =
                                authState.displayProfile.country != null &&
                                        authState.displayProfile.country!.id !=
                                            -1
                                    ? authState.displayProfile.country!.name
                                    : "Country";
                            final bool isEmpty =
                                !(authState.displayProfile.country != null &&
                                    authState.displayProfile.country!.name
                                        .isNotEmpty);

                            return RSelectionField(
                              onpressed: () {
                                NavigationHelpers.push(
                                    context,
                                    EditLocationScreen(
                                      title: "Country",
                                      locations: accountState.listOfCountries,
                                      setLocationFn:
                                          accountState.setSelectedCountry,
                                    ));
                              },
                              text: countryName,
                              isEmpty: isEmpty,
                            ).pAll(12);
                          }),
                          Consumer<AccountSettingsState>(
                              builder: (context, authState, child) {
                            final String stateName =
                                authState.displayProfile.state != null &&
                                        authState.displayProfile.state!.id != -1
                                    ? authState.displayProfile.state!.name
                                    : "State";
                            final bool isEmpty =
                                !(authState.displayProfile.state != null &&
                                    authState
                                        .displayProfile.state!.name.isNotEmpty);

                            return RSelectionField(
                              onpressed: () {
                                NavigationHelpers.push(
                                    context,
                                    EditLocationScreen(
                                      title: "State",
                                      locations: accountState.listOfStates,
                                      setLocationFn:
                                          accountState.setSelectedState,
                                    ));
                              },
                              text: stateName,
                              isEmpty: isEmpty,
                            ).pAll(12);
                          }),
                          Consumer<AccountSettingsState>(
                              builder: (context, authState, child) {
                            final String cityName =
                                authState.displayProfile.city != null &&
                                        authState.displayProfile.city!.id != -1
                                    ? authState.displayProfile.city!.name
                                    : "City";
                            final bool isEmpty =
                                !(authState.displayProfile.city != null &&
                                    authState
                                        .displayProfile.city!.name.isNotEmpty);

                            return RSelectionField(
                              onpressed: () {
                                NavigationHelpers.push(
                                    context,
                                    EditLocationScreen(
                                      title: "City",
                                      locations: accountState.listOfCities,
                                      setLocationFn:
                                          accountState.setSelectedCity,
                                    ));
                              },
                              text: cityName,
                              isEmpty: isEmpty,
                            ).pAll(12);
                          }),
                          RTextField(
                            choice: Choice.optionalText,
                            controller: _streetController,
                            labelText: "Street",
                            onChanged: (value) {
                              accountState.setStreetname(value);
                            },
                          ).pAll(12),
                          RTextField(
                            choice: Choice.optionalText,
                            controller: _postalController,
                            labelText: "Postal/ZIP",
                            onChanged: (value) {
                              accountState.setPostalCode(value);
                            },
                          ).pAll(12),
                        ],
                      ).pH(20),
                    ],
                  ),
                ),
                OverlayLoading(
                  showLoader: _isLoading,
                  loadingMessage: "Saving details...",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
