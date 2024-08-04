import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rasooc/domain/helper/constants.dart';
import 'package:rasooc/domain/helper/utility.dart';
import 'package:rasooc/domain/providers/auth_state.dart';
import 'package:rasooc/presentation/common-widgets/custom_text_field.dart';
import 'package:rasooc/presentation/common-widgets/top_icon.dart';
import 'package:rasooc/presentation/pages/personalize/personalized_details.dart';
import 'package:rasooc/presentation/pages/questionnaire/select_location.dart';
import 'package:rasooc/presentation/themes/extensions.dart';
import 'package:rasooc/presentation/themes/images.dart';
import 'package:rasooc/presentation/themes/styles.dart';
import 'package:rasooc/utils/links.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateProfilePage extends StatefulWidget {
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final state = Provider.of<AuthState>(context, listen: false);
    final profileModel = state.createUserProfile;
    _firstNameController = TextEditingController(text: profileModel?.firstName);
    _lastNameController = TextEditingController(text: profileModel?.lastName);
    _emailController = TextEditingController(text: profileModel?.email);
    if (state.listOfCountries.isEmpty) {
      await state.getCountries();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> saveDetails() async {
    _formKey.currentState!.save();
    final authState = Provider.of<AuthState>(context, listen: false);
    final selectedState = authState.selectedState;
    final selectedCity = authState.selectedCity;

    final bool isValidated = _formKey.currentState!.validate();
    if (isValidated && selectedCity.id != null && selectedState.id != null) {
      print("Validated");

      authState.setFirstName(_firstNameController.text);
      authState.setLastName(_lastNameController.text);
      authState.setEmail(_emailController.text);

      Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => PersonalizedDetailsScreen()));
    } else {
      if (!isValidated) {
        return;
      } else {
        if (selectedState.id == null) {
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
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 32),
                TopIcon(imagePath: RImages.userImage, title: "Contact Details"),
                SizedBox(height: 20),
                RTextField(
                  choice: Choice.name,
                  controller: _firstNameController,
                  labelText: "First name",
                  hintText: "First name",
                ).pAll(8),
                RTextField(
                  choice: Choice.name,
                  controller: _lastNameController,
                  labelText: "Last name",
                  hintText: "Last name",
                ).pAll(8),
                RTextField(
                  choice: Choice.email,
                  controller: _emailController,
                  hintText: "Type your email",
                  labelText: "Contact email",
                ).pAll(8),
                Consumer<AuthState>(builder: (context, state, _) {
                  print(state.selectedState.name);
                  // _city = state.selectedCity.name!;

                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => SelectLocation(
                              onSearch:
                                  Provider.of<AuthState>(context, listen: false)
                                      .setCountrySearchList,
                              locations: state.displayCountryList,
                              setLocationFn:
                                  Provider.of<AuthState>(context, listen: false)
                                      .setSelectedCountry,
                              title: "Country"),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        state.selectedCountry.id != -1
                            ? state.selectedCountry.name
                            : "Select Country",
                        style: state.selectedCountry.id != -1
                            ? RStyles.inputText
                            : RStyles.lableStyle,
                      ),
                    ).pAll(8),
                  );
                }),
                Consumer<AuthState>(builder: (context, state, _) {
                  print(state.selectedState.name);
                  // _city = state.selectedCity.name!;

                  return GestureDetector(
                    onTap: () {
                      if (state.selectedCountry.id != -1) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => SelectLocation(
                                onSearch: Provider.of<AuthState>(context,
                                        listen: false)
                                    .setStateSearchList,
                                locations: state.displayStateList,
                                // locations: state.listOfStates,
                                setLocationFn: Provider.of<AuthState>(context,
                                        listen: false)
                                    .setSelectedState,
                                title: "State"),
                            fullscreenDialog: true,
                          ),
                        );
                      } else {
                        Utility.displaySnackbar(context,
                            key: _scaffoldKey,
                            msg: "Please select a country to continue");
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        state.selectedState.id != -1
                            ? state.selectedState.name
                            : "Select State",
                        style: state.selectedState.id != -1
                            ? RStyles.inputText
                            : RStyles.lableStyle,
                      ),
                    ).pAll(8),
                  );
                }),
                Consumer<AuthState>(builder: (context, state, _) {
                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (state.selectedCountry.id != -1 &&
                          state.selectedState.id != -1) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => SelectLocation(
                                onSearch: Provider.of<AuthState>(context,
                                        listen: false)
                                    .setCitySearchList,
                                locations: state.displayCityList,
                                // locations: state.listOfCities,
                                setLocationFn: Provider.of<AuthState>(context,
                                        listen: false)
                                    .setSelectedCity,
                                title: "City"),
                            fullscreenDialog: true,
                          ),
                        );
                      } else {
                        Utility.displaySnackbar(context,
                            key: _scaffoldKey,
                            msg: state.selectedCountry.id == -1
                                ? "Please select a country to continue"
                                : "Please select a state to continue");
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        state.selectedCity.id != -1
                            ? state.selectedCity.name
                            : "Select city",
                        style: state.selectedCity.id != -1
                            ? RStyles.inputText
                            : RStyles.lableStyle,
                      ),
                    ).pAll(8),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 8, top: 4),
                  child: RichText(
                    text: TextSpan(
                      text: "By continuing. i agree to the",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: ' T&Cs, ',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(Constants.termsAndConditions);
                            },
                        ),
                        TextSpan(
                          text:
                              "and consent to my personal information being used in accordance with the",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        TextSpan(
                          text: ' Privacy Policy. ',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launch(Constants.privacyPolicy);
                            },
                        ),
                        TextSpan(
                          text:
                              "For EU users, Learn more about your rights under thwe Genral Data Protection Regulation (GDPR)",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                Consumer<AuthState>(builder: (context, state, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: SizedBox(
                      height: 48,
                      width: 320,
                      child: FlatButton(
                        color: const Color(0xff27DEBF),
                        textColor: Colors.white,
                        minWidth: double.maxFinite,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        onPressed: () {
                          if (state.selectedCountry.id == -1) {
                            Utility.displaySnackbar(context,
                                key: _scaffoldKey,
                                msg: "Please select a country to continue");
                          } else if (state.selectedState.id == -1) {
                            Utility.displaySnackbar(context,
                                key: _scaffoldKey,
                                msg: "Please select a state to continue");
                          } else if (state.selectedCity.id == -1) {
                            Utility.displaySnackbar(context,
                                key: _scaffoldKey,
                                msg: "Please select a city to continue");
                          } else {
                            saveDetails();
                            // Utility.displaySnackbar(context,
                            //     key: _scaffoldKey,
                            //     msg: "Please select a city to continue");
                          }
                        },
                        child: Text("NEXT"),
                      ),
                    ),
                  );
                }),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
